import 'dart:convert';

import 'package:ale_okaz/screens/register/user.dart';
import 'package:ale_okaz/services/auth_service.dart';
import 'package:ale_okaz/utils/ip.dart';
import 'package:http/http.dart' as http;

class UserService {
  Future<User> getUserInfo(String userId) async {
    final rawUser =
        await AuthService().sendGETRequest('$ip/api/users/info/$userId');

    return User.fromJson(rawUser);
  }
}
