import 'package:ale_okaz/views/layout.dart';
import 'package:ale_okaz/screens/posts/post_card.dart';
import 'package:ale_okaz/view_models/posts/posts_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PostsScreen extends StatelessWidget {
  const PostsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Make sure PostService is registered once (e.g. in main.dart)
    // Get.put(PostService());

    // Instantiate (or retrieve) our VM
    final vm = Get.put(PostsViewModel());

    return Layout(
      body: Obx(() {
        if (vm.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (vm.errorMessage.value != null) {
          return Center(child: Text('Error: ${vm.errorMessage.value}'));
        }

        if (vm.posts.isEmpty) {
          return const Center(child: Text('No posts available'));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: vm.posts.length,
          itemBuilder: (ctx, i) {
            final post = vm.posts[i];
            return PostCard(key: ValueKey(post.id), post: post);
          },
        );
      }),
    );
  }
}
