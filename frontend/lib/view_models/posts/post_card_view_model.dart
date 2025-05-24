import 'package:ale_okaz/utils/comments_controller.dart';
import 'package:ale_okaz/views/comments/comments_sheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ale_okaz/services/post_service.dart';
import 'package:ale_okaz/models/data/post.dart';
import 'package:ale_okaz/utils/parser.dart';

class PostCardViewModel extends GetxController {
  final Post post;
  final Parser _parser = Parser();
  late final CommentsCountController commentsCountController;

  final isLiked = false.obs;
  final likesCount = 0.obs;

  PostCardViewModel(this.post);

  @override
  void onInit() {
    super.onInit();
    commentsCountController = Get.find<CommentsCountController>(tag: post.id);

    likesCount.value = post.reactions.likes;
    isLiked.value = post.reactions.userReaction != null;
    commentsCountController.initCount(post.comments.length);
  }

  String get imageUrl => _parser.getImageUrl(post.imageUrl);
  String get formattedDate => _parser.getDateInPL(post.createdAt);

  Future<void> toggleLike() async {
    isLiked.toggle();
    likesCount.value += isLiked.value ? 1 : -1;

    final success = isLiked.value
        ? await PostService().setReaction(post.id)
        : await PostService().deleteReaction(post.id);

    if (!success) {
      isLiked.toggle();
      likesCount.value += isLiked.value ? 1 : -1;
      Get.snackbar(
        'Error',
        isLiked.value
            ? "Couldn't add reaction to the post"
            : "Couldn't remove reaction from the post",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void openComments(BuildContext context) {
    showCommentsSheet(context, post.id);
  }
}
