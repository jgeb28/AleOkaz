import 'dart:io';

import 'package:ale_okaz/models/services/auth_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:http_parser/http_parser.dart';
import 'dart:convert';
import 'package:ale_okaz/consts/flutter_api_consts.dart';


class RestService extends GetxService {
  final storage = const FlutterSecureStorage();
  final AuthService _authService = AuthService();

   Future<dynamic> sendGETRequest(String url) async {
    try {
      String? accessToken = await storage.read(key: 'accessToken');
      if (accessToken == null) {
        throw 'Brak Tokenu uwierzytelniającego';
      }

      if (await _authService.isTokenExpired(accessToken)) {
        await _authService.refreshAccessToken();
        accessToken = await storage.read(key: 'accessToken');
      }
      final response = await http.get(
        Uri.parse("${FlutterApiConsts.baseUrl}$url"),
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
      throw 'Wystąpił błąd: $e';
    }
  }

  Future<dynamic> sendPOSTRequest(String url, Map<String, dynamic> body) async {
    try {
      String? accessToken = await storage.read(key: 'accessToken');
      if (accessToken == null) {
        throw 'Brak Tokenu uwierzytelniającego';
      }

      if (await _authService.isTokenExpired(accessToken)) {
        await _authService.refreshAccessToken();
        accessToken = await storage.read(key: 'accessToken');
      }

      final response = await http.post(
        Uri.parse("${FlutterApiConsts.baseUrl}/$url"),
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
      throw 'Wystąpił błąd: $e';
    }
  }

  Future<dynamic> sendPUTRequest(String url, Map<String, dynamic> body) async {
    try {
      String? accessToken = await storage.read(key: 'accessToken');
      if (accessToken == null) {
        throw 'Brak Tokenu uwierzytelniającego';
      }

      if (await _authService.isTokenExpired(accessToken)) {
        await _authService.refreshAccessToken();
        accessToken = await storage.read(key: 'accessToken');
      }

      final response = await http.put(
        Uri.parse("${FlutterApiConsts.baseUrl}/$url"),
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
      throw 'Wystąpił błąd: $e';
    }
  }

  Future<void> updateUserInfo({Map<String, dynamic>? data, File? imageFile}) async {
    try {
      String? accessToken = await storage.read(key: 'accessToken');
      if (accessToken == null) {
        throw 'Brak Tokenu uwierzytelniającego';
      }

      if (await _authService.isTokenExpired(accessToken)) {
        await _authService.refreshAccessToken();
        accessToken = await storage.read(key: 'accessToken');
      }
      var uri = Uri.parse('${FlutterApiConsts.baseUrl}/users/info');

      var request = http.MultipartRequest('PUT', uri);

      if (data != null && data.isNotEmpty) {
        request.files.add(http.MultipartFile.fromString(
            'userInfo', jsonEncode(data),
            contentType: MediaType('application', 'json')));
      }

      if (imageFile != null) {
        String extension = basename(imageFile.path).split('.').last.toLowerCase();
        MediaType mediaType;

        switch (extension) {
          case 'jpg':
          case 'jpeg':
            mediaType = MediaType('image', 'jpeg');
            break;
          case 'png':
            mediaType = MediaType('image', 'png');
            break;
          default:
            mediaType = MediaType('image', 'jpeg');
            break;
        }

        request.files.add(await http.MultipartFile.fromPath(
            'image', imageFile.absolute.path,
            contentType: mediaType));
      }

      request.headers['authorization'] = 'Bearer $accessToken';

      var response = await request.send();

      if (response.statusCode == 201) {
        ;
      } else {
        final respStr = await response.stream.bytesToString();
        throw Exception('Request failed: $respStr');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }


}