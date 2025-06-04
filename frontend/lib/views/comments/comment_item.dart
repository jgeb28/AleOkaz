// lib/widgets/posts/comment_item.dart
import 'dart:convert';

import 'package:ale_okaz/view_models/comments/comment_item_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:readmore/readmore.dart';
import 'package:ale_okaz/utils/parser.dart';
import 'package:ale_okaz/models/data/comment.dart';
import 'package:ale_okaz/models/data/user.dart';
import 'package:ale_okaz/widgets/posts/interaction_button.dart';

class CommentItem extends StatelessWidget {
  final Comment comment;
  final User user;

  const CommentItem({
    super.key,
    required this.comment,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    // Register or retrieve the ViewModel, one per comment.id
    final vm = Get.put(CommentItemViewModel(comment), tag: comment.id);
    final parser = Parser();

    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User avatar
          InkWell(
            onTap: () => Get.toNamed('/profile/${user.id}'),
            child: CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(
                parser.getImageUrl(user.profilePictureUrl),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Username, timestamp, and content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      user.username,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      parser.getDateInPL(comment.createdAt),
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                ReadMoreText(
                  comment.content,
                  trimLines: 2,
                  trimMode: TrimMode.Line,
                  trimCollapsedText: 'więcej',
                  trimExpandedText: ' mniej',
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),

          // Like button
          Obx(() => InteractionButton(
                number: vm.likesCount.value,
                isNumberDisplayed: true,
                isRow: false,
                icon: vm.isLiked.value ? Icons.favorite : Icons.favorite_border,
                onPressed: vm.toggleLike,
              )),
        ],
      ),
    );
  }
}
