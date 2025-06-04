import 'package:get/get.dart';
import 'package:ale_okaz/models/data/post.dart';
import 'package:ale_okaz/services/post_service.dart';

class PostViewModel extends GetxController {
  final String postId;
  final _service = PostService();

  final isLoading = true.obs;
  final errorMessage = RxnString();
  final post = Rxn<Post>();

  PostViewModel(this.postId) {
    loadPost();
  }

  Future<void> loadPost() async {
    try {
      isLoading.value = true;
      final fetched = await _service.getPost(postId);
      post.value = fetched;
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
