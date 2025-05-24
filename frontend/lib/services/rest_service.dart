import 'dart:io';

import 'package:ale_okaz/consts/flutter_api_consts.dart';
import 'package:ale_okaz/utils/ip.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart';

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
          Uri.parse('${FlutterApiConsts.baseUrl}/api/users/refresh'),
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

    final finalUrl = '${FlutterApiConsts.baseUrl}/$url';

    final response = await http.get(
      Uri.parse(finalUrl),
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

    final finalUrl = '${FlutterApiConsts.baseUrl}/$url';

    final response = await http.put(
      Uri.parse(finalUrl),
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

    final finalUrl = '${FlutterApiConsts.baseUrl}/$url';

    final response = await http.delete(
      Uri.parse(finalUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Błędna odpowiedź serwera – ${response.statusCode}');
    }
  }

  /// Sends a POST request, decodes the JSON response via [parser].
  Future<T> sendPOSTRequest<T>(
    String url, {
    dynamic payload,
    required T Function(dynamic decodedJson) parser,
  }) async {
    var accessToken = await storage.read(key: 'accessToken');
    if (accessToken == null) {
      throw Exception('Brak Tokenu uwierzytelniającego');
    }
    if (await isTokenExpired(accessToken)) {
      await refreshAccessToken();
      accessToken = (await storage.read(key: 'accessToken'))!;
    }

    final finalUrl = '${FlutterApiConsts.baseUrl}/$url';

    final response = await http.post(
      Uri.parse(finalUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: payload != null ? jsonEncode(payload) : null,
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Błędna odpowiedź serwera – ${response.statusCode}');
    }

    final decoded = jsonDecode(response.body);
    return parser(decoded);
  }

  Future<void> updateUserInfo(
      {Map<String, dynamic>? data, File? imageFile}) async {
    try {
      String? accessToken = await storage.read(key: 'accessToken');
      if (accessToken == null) {
        throw 'Brak Tokenu uwierzytelniającego';
      }

      if (await isTokenExpired(accessToken)) {
        await refreshAccessToken();
        accessToken = await storage.read(key: 'accessToken');
      }
      var uri = Uri.parse('${FlutterApiConsts.baseUrl}/api/users/info');

      var request = http.MultipartRequest('PUT', uri);

      if (data != null && data.isNotEmpty) {
        request.files.add(http.MultipartFile.fromString(
            'userInfo', jsonEncode(data),
            contentType: MediaType('application', 'json')));
      }

      if (imageFile != null) {
        String extension =
            basename(imageFile.path).split('.').last.toLowerCase();
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
