import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthService {
  final storage = const FlutterSecureStorage();

  Future<void> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:8080/api/users/login'),
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

        await storage.write(key: 'accessToken', value: accessToken);
        await storage.write(key: 'refreshToken', value: refreshToken);

        return;

      } else {
        throw('Błędna odpowiedź serwera - ${response.statusCode}');
      }
      
    } catch(e) {
      throw('Wystąpił błąd: $e');
    }

  }

  Future<void> refreshAccessToken() async {
    final refreshToken = await storage.read(key: 'refreshToken');
    if (refreshToken != null) {
      try {
       final response = await http.post(
        Uri.parse('http://10.0.2.2:8080/api/users/refresh'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'refreshToken': refreshToken,
        }),
      );

        final accessToken = jsonDecode(response.body)['accessToken'];
        if (accessToken != null) {
          await storage.write(
              key: 'accessToken', value: accessToken);
          return;
        } 
      } catch (e) {
        throw('Nie udało się odświeżyć tokenu: $e');
      }
    }

    // Clear stored tokens if refresh token is invalid or refresh request fails
    await storage.delete(key: 'accessToken');
    await storage.delete(key: 'refreshToken');
  }

  Future<void> logout() async {
    await storage.delete(key: 'accessToken');
    await storage.delete(key: 'refreshToken');
  }

  Future<void> sendToken(String email) async {
    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:8080/api/recovery'),
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
        throw('Błędna odpowiedź serwera - ${response.statusCode}');
      }
      
    } catch(e) {
      throw('Wystąpił błąd: $e');
    }

  }

  Future<bool> verifyToken(String email, String token) async {
    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:8080/api/recovery/verifyToken'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
         'email': email,
         'token': token
        }),
      );

      if (response.statusCode == 200) {
        storage.write(key: "resetToken", value: token);
        return true;

      } else {
        throw('Błędna odpowiedź serwera - ${response.statusCode}');
      }
      
    } catch(e) {
      throw('Wystąpił błąd: $e');
    }

  }

  

  Future<void> changePassword(String email, String password) async {
    final token = await storage.read(key: 'resetToken');
    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:8080/api/recovery/resetPassword'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': email,
          'token': token.toString(),
          'password': password
        }),
      );

      if (response.statusCode == 200) {
        storage.delete(key: 'resetToken');
        return;

      } else {
        throw('Błędna odpowiedź serwera - ${response.statusCode}');
      }
      
    } catch(e) {
      throw('Wystąpił błąd: $e');
    }

  }

}