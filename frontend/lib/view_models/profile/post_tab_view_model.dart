import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:ale_okaz/services/rest_service.dart';
import 'package:ale_okaz/models/data/post_miniature.dart';

class PostsTabViewModel extends GetxController {
  final RestService _restService = RestService();

  final String userId;
  final RxList<PostMiniature> postsList = <PostMiniature>[].obs;

  Future<void> getAllPosts() async {
    try {
      final response = await _restService
          .sendGETRequest<List<PostMiniature>>('api/posts', (decodedJson) {
        return List<PostMiniature>.from(decodedJson.map((postMini) =>
            PostMiniature.fromJson(postMini as Map<String, dynamic>)));
      });

      postsList.value = response.toList();
    } catch (e) {
      Get.snackbar(
        'Błąd',
        'Błąd podczas pobierania postów: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(8),
      );
    }
  }

  PostsTabViewModel(this.userId);
}
