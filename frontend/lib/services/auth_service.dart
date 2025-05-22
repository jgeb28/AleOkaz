import 'package:ale_okaz/consts/flutter_api_consts.dart';
import 'package:ale_okaz/models/data/user.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:ale_okaz/utils/ip.dart';

import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final storage = const FlutterSecureStorage();

  Future<void> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$ip/api/users/login'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'username': username,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final accessToken = jsonDecode(response.body)['accessToken'];
        final refreshToken = jsonDecode(response.body)['refreshToken'];

        print("accessToken: " + accessToken);
        await storage.write(key: 'accessToken', value: accessToken);
        await storage.write(key: 'refreshToken', value: refreshToken);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('username', username);

        return;
      } else {
        throw ('Błędna odpowiedź serwera - ${response.statusCode}');
      }
    } catch (e) {
      throw ('Wystąpił błąd: $e');
    }
  }

  Future<dynamic> sendGETRequest(String url) async {
    try {
      String? accessToken = await storage.read(key: 'accessToken');
      if (accessToken == null) {
        throw 'Brak Tokenu uwierzytelniającego';
      }

      if (await isTokenExpired(accessToken)) {
        await refreshAccessToken();
        accessToken = await storage.read(key: 'accessToken');
      }

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          "Authorization": "Bearer $accessToken",
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw 'Błędna odpowiedź serwera - ${response.statusCode}';
      }
    } catch (e) {
      return 'Wystąpił błąd: $e';
    }
  }

  Future<dynamic> sendPOSTRequest(String url, Map<String, dynamic> body) async {
    try {
      String? accessToken = await storage.read(key: 'accessToken');
      if (accessToken == null) {
        throw 'Brak Tokenu uwierzytelniającego';
      }

      if (await isTokenExpired(accessToken)) {
        await refreshAccessToken();
        accessToken = await storage.read(key: 'accessToken');
      }

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          "Authorization": "Bearer $accessToken",
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw 'Błędna odpowiedź serwera - ${response.statusCode}';
      }
    } catch (e) {
      return 'Wystąpił błąd: $e';
    }
  }

  Future<bool> isTokenExpired(String token) async {
    if (token.isEmpty) return true;

    try {
      final parts = token.split('.');
      if (parts.length != 3) return true;

      final payload = json.decode(utf8.decode(base64Url.decode(parts[1])));
      final exp = payload['exp'];

      if (exp == null) return true;

      final expiryDate = DateTime.fromMillisecondsSinceEpoch(exp * 1000);
      return DateTime.now().isAfter(expiryDate);
    } catch (e) {
      return true;
    }
  }

  Future<void> refreshAccessToken() async {
    final refreshToken = await storage.read(key: 'refreshToken');
    if (refreshToken != null) {
      try {
        final response = await http.post(
          Uri.parse('$ip/api/users/refresh'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            'refreshToken': refreshToken,
          }),
        );

        final accessToken = jsonDecode(response.body)['accessToken'];
        if (accessToken != null) {
          await storage.write(key: 'accessToken', value: accessToken);
          return;
        }
      } catch (e) {
        throw ('Nie udało się odświeżyć tokenu: $e');
      }
    }

    logout();
  }

  Future<void> sendResetToken(String email) async {
    try {
      final response = await http.post(
        Uri.parse('${FlutterApiConsts.baseUrl}/api/recovery'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': email,
        }),
      );

      if (response.statusCode == 200) {
        return;
      } else {
        throw ('Błędna odpowiedź serwera - ${response.statusCode}');
      }
    } catch (e) {
      throw ('Wystąpił błąd: $e');
    }
  }

  Future<bool> verifyResetToken(String email, String token) async {
    try {
      final response = await http.post(
        Uri.parse('${FlutterApiConsts.baseUrl}/api/recovery/verifyToken'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{'email': email, 'token': token}),
      );

      if (response.statusCode == 200) {
        storage.write(key: "resetToken", value: token);
        return true;
      } else {
        throw ('Błędna odpowiedź serwera - ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw ('Wystąpił błąd: $e');
    }
  }

  Future<void> changePassword(String email, String password) async {
    final resetToken = await storage.read(key: 'resetToken');
    if (resetToken == null) {
      throw 'Brak Tokenu resetującego';
    }
    try {
      final response = await http.post(
        Uri.parse('${FlutterApiConsts.baseUrl}/api/recovery/resetPassword'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': email,
          'token': resetToken.toString(),
          'password': password
        }),
      );

      if (response.statusCode == 200) {
        storage.delete(key: 'resetToken');
        return;
      } else {
        throw ('Błędna odpowiedź serwera - ${response.statusCode}');
      }
    } catch (e) {
      throw ('Wystąpił błąd: $e');
    }
  }

  Future<User> createUser(
      String username, String email, String password) async {
    final uri = Uri.parse('$ip/api/users');

    try {
      final response = await http.post(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'username': username,
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 201) {
        return User.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
      } else {
        final error = jsonDecode(response.body) as Map<String, dynamic>;
        throw Exception(
            'Failed to create user: ${error['message'] ?? 'Unknown error'}');
      }
    } catch (e) {
      throw Exception('An error occurred: $e');
    }
  }

  Future<void> logout() async {
    clearTokens();
    Get.offAllNamed('/login');
  }

  Future<void> clearTokens() async {
    await storage.delete(key: 'accessToken');
    await storage.delete(key: 'refreshToken');
  }

  Future<String?> getAccessToken() async {
    return await storage.read(key: 'accessToken');
  }
}
