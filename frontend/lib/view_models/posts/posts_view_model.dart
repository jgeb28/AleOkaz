import 'package:ale_okaz/models/data/post.dart';
import 'package:ale_okaz/services/post_service.dart';
import 'package:ale_okaz/services/rest_service.dart';
import 'package:get/get.dart';

class PostsViewModel extends GetxController {
  final PostService _service = PostService();
  final RestService _restService = RestService();

  final posts = <Post>[].obs;

  final isLoading = false.obs;
  final errorMessage = RxnString();

  @override
  void onInit() {
    super.onInit();

    final spotId = Get.parameters['spotId'];
    print(spotId);
    if (spotId != null) {
      fetchPostsForSpot(spotId);
    } else {
      fetchPosts();
    }
  }

  Future<void> fetchPostsForSpot(String spotId) async {
    try {
      isLoading.value = true;
      errorMessage.value = null;

      final spot = await _restService.sendGETRequest<Map<String, dynamic>>(
        'api/fishingspots/$spotId',
        (json) {
          if (json is Map<String, dynamic>) {
            return json;
          } else {
            throw Exception("Invalid response format");
          }
        },
      );

      final postsJson = spot['posts'] as List<dynamic>;

      posts.value = postsJson
          .map((postJson) => Post.fromJson(postJson))
          .toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchPosts() async {
    try {
      isLoading.value = true;
      errorMessage.value = null;
      final fetched = await _service.getPosts();
      fetched.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      posts.value = fetched;
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
