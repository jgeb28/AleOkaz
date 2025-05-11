import 'package:ale_okaz/utils/ip.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;

class RestService {
  final storage = const FlutterSecureStorage();

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

  Future<T> sendGETRequest<T>(
    String url,
    T Function(dynamic decodedJson) parser,
  ) async {
    final storedToken = await storage.read(key: 'accessToken');
    if (storedToken == null) {
      throw Exception('Brak Tokenu uwierzytelniającego');
    }

    String accessToken = storedToken;

    if (await isTokenExpired(accessToken)) {
      await refreshAccessToken();
      accessToken = (await storage.read(key: 'accessToken'))!;
    }

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Błędna odpowiedź serwera – ${response.statusCode}');
    }

    final decoded = jsonDecode(response.body);
    return parser(decoded);
  }

  Future<void> sendPUTRequestNoResponse(
    String url, {
    dynamic? payload,
  }) async {
    final storedToken = await storage.read(key: 'accessToken');
    if (storedToken == null) {
      throw Exception('Brak Tokenu uwierzytelniającego');
    }
    String accessToken = storedToken;

    if (await isTokenExpired(accessToken)) {
      await refreshAccessToken();
      accessToken = (await storage.read(key: 'accessToken'))!;
    }

    final response = await http.put(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: payload != null ? jsonEncode(payload) : null,
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Błędna odpowiedź serwera – ${response.statusCode}');
    }
  }

  Future<void> sendDELETERequestNoResponse(String url) async {
    final storedToken = await storage.read(key: 'accessToken');
    if (storedToken == null) {
      throw Exception('Brak Tokenu uwierzytelniającego');
    }
    String accessToken = storedToken;

    if (await isTokenExpired(accessToken)) {
      await refreshAccessToken();
      accessToken = (await storage.read(key: 'accessToken'))!;
    }

    final response = await http.delete(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Błędna odpowiedź serwera – ${response.statusCode}');
    }
  }
}
