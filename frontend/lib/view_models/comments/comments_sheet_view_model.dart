// lib/view_models/posts/comments_sheet_view_model.dart
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:ale_okaz/services/post_service.dart';
import 'package:ale_okaz/models/data/comment.dart';
import 'package:ale_okaz/utils/comments_controller.dart';

class CommentsSheetViewModel extends GetxController {
  final String postId;
  final PostService _service = PostService();

  late CommentsCountController _countController;

  final comments = <Comment>[].obs;
  final isLoading = false.obs;
  final isSending = false.obs;
  final textController = TextEditingController();

  CommentsSheetViewModel(this.postId);

  @override
  void onInit() {
    super.onInit();
    _countController = Get.find<CommentsCountController>(tag: postId);

    _loadComments();
  }

  Future<void> _loadComments() async {
    try {
      isLoading.value = true;
      final fetched = await _service.getComments(postId);
      print(fetched[0].createdAt);
      fetched.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      comments.assignAll(fetched);
    } catch (e) {
      Get.snackbar(
        'Błąd',
        'Błąd przy ładowaniu komentarzy: $e',
        backgroundColor: Colors.red,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> sendComment() async {
    final text = textController.text.trim();
    if (text.isEmpty) return;

    isSending.value = true;
    try {
      final newComment = await _service.createComment(postId, text);

      comments.add(newComment);
      comments.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      textController.clear();
      _countController.increment();
    } catch (e) {
      Get.snackbar(
        'Błąd',
        'Nie udało się dodać komentarza: $e',
        backgroundColor: Colors.red,
      );
    } finally {
      isSending.value = false;
    }
  }

  @override
  void onClose() {
    textController.dispose();
    super.onClose();
  }
}
