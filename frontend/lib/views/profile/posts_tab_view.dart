import 'package:ale_okaz/view_models/profile/post_tab_view_model.dart';
import 'package:ale_okaz/widgets/post_miniature_container.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PostsTab extends StatefulWidget {
  const PostsTab({required this.isMyProfile, required this.userId, super.key});

  final bool isMyProfile;
  final String userId;

  @override
  State<PostsTab> createState() => _PostsTabState();
}

class _PostsTabState extends State<PostsTab> {
  late PostsTabViewModel _viewModel;

  @override
  void initState() {
    Get.delete<PostsTabViewModel>();
    _viewModel = Get.put(PostsTabViewModel(widget.userId));
    super.initState();
  }

  @override
  void dispose() {
    Get.delete<PostsTabViewModel>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _viewModel.getAllPosts();

    return Obx(() {
      if (_viewModel.postsList.isEmpty) {
        return const Center(
          child: Text(
            "Nie znaleziono postów :)",
          ),
        );
      }

      return GridView.builder(
        padding: const EdgeInsets.all(8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 6,
          mainAxisSpacing: 6,
        ),
        itemCount: _viewModel.postsList.length,
        itemBuilder: (context, i) {
          return PostMiniatureContainer(post: _viewModel.postsList[i]);
        },
      );
    });
  }
}
