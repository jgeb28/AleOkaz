import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ale_okaz/consts/colors.dart';
import 'package:ale_okaz/utils/parser.dart';
import 'package:ale_okaz/view_models/posts/post_top_bar_view_model.dart';

class PostTopBar extends StatelessWidget {
  final String userId;
  final String location;

  const PostTopBar({
    super.key,
    required this.userId,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    return GetX<PostTopBarViewModel>(
      tag: userId,
      init: PostTopBarViewModel(userId),
      builder: (vm) {
        if (vm.isLoading.value) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        if (vm.error.value != null) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Error loading user',
              style: TextStyle(color: Colors.red),
            ),
          );
        }

        final user = vm.user.value!;
        final avatarUrl = Parser().getImageUrl(user.profilePictureUrl);

        return Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              CircleAvatar(
                  radius: 20, backgroundImage: NetworkImage(avatarUrl)),
              const SizedBox(width: 12),
              Text(
                user.username,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const Spacer(),
              Row(
                children: [
                  Text(location),
                  const SizedBox(width: 8),
                  const Icon(Icons.location_on, color: buttonBackgroundColor),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
