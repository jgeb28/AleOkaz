import 'package:ale_okaz/models/data/post.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:ale_okaz/models/services/rest_service.dart';

class PostsTabViewModel extends GetxController {
  final RestService _restService = RestService();

  final String userId;
  final RxList<PostMiniature> postsList = <PostMiniature>[].obs;

  Future<void> getAllPosts() async {
  try {

    final response = await _restService.sendGETRequest(
      '/posts'
    );

    postsList.value = List<PostMiniature>.from(
      response.map((postMini) => PostMiniature.fromJson(postMini as Map<String, dynamic>))
              .toList()
      );
    


  } catch (e) {
    Get.snackbar(
      'Błąd',
      'Error fetching posts: $e',
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