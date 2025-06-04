import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ale_okaz/services/post_service.dart';

class CreatePostFormViewModel extends GetxController {
  /// Form key & controllers
  final String imagePath;
  CreatePostFormViewModel(this.imagePath);

  final formKey = GlobalKey<FormState>();
  final descriptionController = TextEditingController();

  final _postService = PostService();

  @override
  void onClose() {
    descriptionController.dispose();
    super.onClose();
  }

  /// Submit logic extracted here
  Future<void> submitForm() async {
    if (!formKey.currentState!.validate()) return;
    try {
      print("Byłem tutaj");
      final response = await _postService.createPost(
        "api/posts",
        descriptionController.text,
        // imagePath is passed in via tag args
        imagePath,
      );
      print(response.toString());
      if (response['error'] == true) {
        Get.snackbar(
          'Błąd',
          response['message'],
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        Get.snackbar(
          'Sukces',
          'Post został utworzony',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
        Get.offNamed('/home');
      }
    } catch (e) {
      Get.snackbar(
        'Błąd',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
