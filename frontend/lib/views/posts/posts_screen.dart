import 'package:ale_okaz/views/layout.dart';
import 'package:ale_okaz/view_models/posts/posts_view_model.dart';
import 'package:ale_okaz/views/posts/post_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PostsScreen extends StatefulWidget {
  const PostsScreen({super.key});

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  late PostsViewModel vm;

  @override
  void initState() {
    super.initState();

    Get.delete<PostsViewModel>(force: true);
    vm = Get.put(PostsViewModel());
  }

  @override
  void dispose() {
    Get.delete<PostsViewModel>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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

            return PostCard(post: post);
          },
        );
      }),
    );
  }
}
