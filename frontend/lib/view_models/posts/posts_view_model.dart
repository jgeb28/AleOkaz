import 'package:ale_okaz/models/data/post.dart';
import 'package:ale_okaz/services/post_service.dart';
import 'package:get/get.dart';

class PostsViewModel extends GetxController {
  final PostService _service = PostService();

  final posts = <Post>[].obs;

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
