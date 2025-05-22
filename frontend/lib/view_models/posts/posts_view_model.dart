// lib/viewmodels/posts_view_model.dart

import 'package:ale_okaz/models/data/post.dart';
import 'package:ale_okaz/services/post_service.dart';
import 'package:get/get.dart';

class PostsViewModel extends GetxController {
  final _service = Get.find<PostService>();

  // Observable list of posts
  final posts = <Post>[].obs;

  // Loading & error state
  final isLoading = false.obs;
  final errorMessage = RxnString();

  @override
  void onInit() {
    super.onInit();
    fetchPosts();
  }

  Future<void> fetchPosts() async {
    try {
      isLoading.value = true;
      errorMessage.value = null;
      final fetched = await _service.getPosts();
      posts.value = fetched;
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
