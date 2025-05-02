import 'dart:convert';
import 'package:ale_okaz/utils/ip.dart';
import 'package:http/http.dart' as http;

import 'package:ale_okaz/screens/register/user.dart';

Future<User> createUser(String username, String email, String password) async {
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
