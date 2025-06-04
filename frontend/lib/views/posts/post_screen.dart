// lib/views/posts/post_screen.dart
import 'package:ale_okaz/view_models/posts/post_screen_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ale_okaz/views/layout.dart';
import 'package:ale_okaz/views/posts/post_card.dart';

class PostScreen extends StatelessWidget {
  const PostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final postId = Get.parameters['postId'];

    if (postId == null) {
      return const Scaffold(
        body: Center(child: Text('Brak ID posta')),
      );
    }

    Get.put(PostViewModel(postId), tag: postId);
    final vm = Get.find<PostViewModel>(tag: postId);

    return Layout(
      hasBackButton: true,
      body: Obx(() {
        if (vm.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (vm.errorMessage.value != null) {
          return Center(child: Text('Błąd: ${vm.errorMessage.value}'));
        }

        if (vm.post.value == null) {
          return const Center(child: Text('Nie znaleziono posta'));
        }

        // Pass the fetched post to PostCard
        return Container(
          margin: const EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: PostCard(post: vm.post.value!),
          ),
        );
      }),
    );
  }
}
