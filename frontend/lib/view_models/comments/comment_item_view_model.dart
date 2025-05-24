// lib/view_models/posts/comment_item_view_model.dart
import 'package:get/get.dart';
import 'package:ale_okaz/services/post_service.dart';
import 'package:ale_okaz/models/data/comment.dart';
import 'package:flutter/material.dart';

class CommentItemViewModel extends GetxController {
  final Comment comment;
  final PostService _service = PostService();

  /// Reactive like state
  final isLiked = false.obs;
  final likesCount = 0.obs;

  CommentItemViewModel(this.comment);

  @override
  void onInit() {
    super.onInit();
    // grab your singleton service
    likesCount.value = comment.reactions.likes;
    isLiked.value = comment.reactions.userReaction != null;
  }

  /// Toggle like/unlike on the comment
  Future<void> toggleLike() async {
    // optimistic update
    isLiked.toggle();
    likesCount.value += isLiked.value ? 1 : -1;

    final success = isLiked.value
        ? await _service.setCommentReaction(comment.id)
        : await _service.deleteCommentReaction(comment.id);

    if (!success) {
      // rollback on failure
      isLiked.toggle();
      likesCount.value += isLiked.value ? 1 : -1;
      Get.snackbar(
        'Error',
        isLiked.value
            ? "Couldn't add reaction to the comment"
            : "Couldn't remove reaction from the comment",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
    print("success");
  }
}
