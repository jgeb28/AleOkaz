import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthService {
  final storage = const FlutterSecureStorage();

  Future<void> login(String username, String password) async {
    try {
      final response = await http.post(
<<<<<<< HEAD
        Uri.parse('http://10.0.2.2:8080/api/users/login'),
=======
        Uri.parse('http://10.0.2.2:8080/login'),
>>>>>>> loginUI
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
<<<<<<< HEAD
        Uri.parse('http://10.0.2.2:8080/api/users/refresh'),
=======
        Uri.parse('http://localhost:8080/api/refresh'),
>>>>>>> loginUI
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

}