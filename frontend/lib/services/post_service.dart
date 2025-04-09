import 'dart:convert';
import 'dart:io';
import 'package:ale_okaz/services/auth_service.dart';
import 'package:ale_okaz/utils/ip.dart';
import 'package:ale_okaz/utils/post.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class PostService {
  final String serverUrl = "$ip:8080";
  final _authService = AuthService();
  final storage = const FlutterSecureStorage();

  Future<dynamic> createPost(
      String url, String description, String filename) async {
    try {
      String? accessToken = await storage.read(key: 'accessToken');
      if (accessToken == null) {
        throw 'Brak Tokenu uwierzytelniającego';
      }

      if (await _authService.isTokenExpired(accessToken)) {
        await _authService.refreshAccessToken();
        accessToken = await storage.read(key: 'accessToken');
      }

      File imageFile = File(filename);

      var request =
          await http.MultipartRequest("POST", Uri.parse('$serverUrl/$url'));

      request.headers['authorization'] = 'Bearer $accessToken';

      request.files.add(http.MultipartFile.fromString(
          'post', jsonEncode({'content': description}),
          contentType: MediaType('application', 'json')));

      request.files.add(await http.MultipartFile.fromPath(
          'image', imageFile.absolute.path,
          contentType: MediaType('image', 'jpeg')));

      var response = await request.send();

      if (response.statusCode == 201) {
        return jsonDecode(await response.stream.bytesToString());
      } else {
        return {'status': response.statusCode, 'error': true};
      }
    } catch (e) {
      throw Exception('Wystąpił błąd: $e');
    }
  }

  // for now it returns all posts (shouldn't be like that)
  Future<List<Post>> getPosts() async {
    final response = await http.get(Uri.parse('$serverUrl/api/posts'));

    if (response.statusCode == 200) {
      final List<dynamic> postsJson = jsonDecode(response.body);

      print(postsJson);
      final List<Post> posts =
          postsJson.map((json) => Post.fromJson(json)).toList();
      print(posts);
      return posts;
    } else {
      throw Exception('Failed to load posts');
    }
  }
}
