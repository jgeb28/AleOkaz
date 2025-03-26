import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

class PostService {
  String serverUrl = "http://10.0.2.2:8080";

  Future<dynamic> createPost(
      String url, String description, String filename) async {
    try {
      File imageFile = File(filename);

      var request = http.MultipartRequest('POST', Uri.parse('$serverUrl/$url'));
      request.fields['description'] = description;

      request.files.add(await http.MultipartFile.fromPath(
          'image', imageFile.path,
          filename: filename));

      var streamedResponse = await request.send();

      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return 'Error: ${response.statusCode} - ${response.body}';
      }
    } catch (e) {
      return 'Exception: $e';
    }
  }
}
