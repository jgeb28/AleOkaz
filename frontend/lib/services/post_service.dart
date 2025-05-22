import 'dart:convert';
import 'dart:io';
import 'package:ale_okaz/services/rest_service.dart';
import 'package:ale_okaz/models/data/comment.dart';
import 'package:ale_okaz/utils/ip.dart';
import 'package:ale_okaz/models/data/post.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:jwt_decode/jwt_decode.dart';

class PostService {
  final String serverUrl = ip;
  final storage = const FlutterSecureStorage();
  final _restService = RestService();

  Future<dynamic> createPost(
      String url, String description, String filename) async {
    try {
      String? accessToken = await storage.read(key: 'accessToken');
      if (accessToken == null) {
        throw 'Brak Tokenu uwierzytelniającego';
      }

      if (await _restService.isTokenExpired(accessToken)) {
        await _restService.refreshAccessToken();
        accessToken = await storage.read(key: 'accessToken');
      }

      File imageFile = File(filename);

      var request = http.MultipartRequest("POST", Uri.parse('$serverUrl/$url'));

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

  Future<List<Post>> getPosts() {
    return _restService.sendGETRequest<List<Post>>(
      '$serverUrl/api/posts',
      (decodedJson) {
        if (decodedJson is List) {
          return decodedJson
              .map((json) => Post.fromJson(json as Map<String, dynamic>))
              .toList();
        }
        throw Exception('Unexpected JSON format for posts');
      },
    );
  }

  Future<List<Post>> getUserPosts() async {
    final token = await storage.read(key: 'accessToken');

    if (token == null) {
      throw Exception('Failed to load posts');
    }

    final userId = Jwt.parseJwt(token)['sub'];

    final response = await http.get(
        Uri.parse('$serverUrl/api/posts?userId=$userId'),
        headers: {'Authorization': 'Bearer $token'});

    if (response.statusCode == 200) {
      final List<dynamic> postsJson = jsonDecode(response.body);

      final List<Post> posts =
          postsJson.map((json) => Post.fromJson(json)).toList();

      return posts;
    } else {
      throw Exception('Failed to load posts');
    }
  }

  Future<bool> setReaction(String postId,
      [String reactionType = 'LIKE']) async {
    final token = await storage.read(key: 'accessToken');

    if (token == null) {
      throw Exception('Failed to make a reaction');
    }

    try {
      final response = await http.put(
          Uri.parse('$serverUrl/api/posts/$postId/reactions'),
          headers: {'Authorization': 'Bearer $token'});

      return response.statusCode == 204;
    } catch (error) {
      return false;
    }
  }

  Future<bool> deleteReaction(String postId,
      [String reactionType = 'LIKE']) async {
    final token = await storage.read(key: 'accessToken');

    if (token == null) {
      throw Exception('Failed to make a reaction');
    }

    try {
      final response = await http.delete(
          Uri.parse('$serverUrl/api/posts/$postId/reactions'),
          headers: {'Authorization': 'Bearer $token'});

      return response.statusCode == 204;
    } catch (error) {
      return false;
    }
  }

  Future<bool> setCommentReaction(String commentId) async {
    try {
      print(commentId);
      await _restService.sendPUTRequestNoResponse(
          '$serverUrl/api/comments/$commentId/reactions');

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> deleteCommentReaction(String commentId) async {
    try {
      print(commentId);
      await _restService.sendDELETERequestNoResponse(
          '$serverUrl/api/comments/$commentId/reactions');

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<List<Comment>> getComments(String postId) async {
    final Post post = await _restService.sendGETRequest(
        '$ip/api/posts/$postId', (decodedJson) => Post.fromJson(decodedJson));

    return post.comments;
  }

  Future<Comment> createComment(String postId, String content) {
    return _restService.sendPOSTRequest('$ip/api/comments',
        payload: {'parentId': postId, 'content': content},
        parser: (decodedJson) => Comment.fromJson(decodedJson));
  }
}
