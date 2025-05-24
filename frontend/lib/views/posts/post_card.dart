// post_card.dart
import 'package:ale_okaz/consts/colors.dart';
import 'package:ale_okaz/utils/comments_controller.dart';
import 'package:ale_okaz/view_models/posts/post_card_view_model.dart';
import 'package:ale_okaz/views/posts/post_top_bar.dart';
import 'package:ale_okaz/widgets/posts/interaction_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ale_okaz/models/data/post.dart';
import 'package:readmore/readmore.dart';

class PostCard extends StatelessWidget {
  final Post post;
  const PostCard({required this.post, super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(CommentsCountController(), tag: post.id);
    final vm = Get.put(PostCardViewModel(post), tag: post.id);

    return Card(
      color: componentColor,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PostTopBar(userId: post.authorId, location: post.location),
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.5,
            ),
            child: AspectRatio(
              aspectRatio: 1,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(vm.imageUrl, fit: BoxFit.cover)),
            ),
          ),
          Row(
            children: [
              Obx(() => InteractionButton(
                    number: vm.likesCount.value,
                    isNumberDisplayed: true,
                    icon: vm.isLiked.value
                        ? Icons.favorite
                        : Icons.favorite_border,
                    onPressed: vm.toggleLike,
                  )),
              const SizedBox(width: 2),
              Obx(() => InteractionButton(
                    number: vm.commentsCountController.count.value,
                    isNumberDisplayed: true,
                    icon: Icons.comment,
                    onPressed: () => vm.openComments(context),
                  )),
              const Spacer(),
              InteractionButton(icon: Icons.share, onPressed: () {}),
            ],
          ),
          if (post.content.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: ReadMoreText(
                post.content,
                style: const TextStyle(fontSize: 16),
                trimMode: TrimMode.Line,
                trimLines: 2,
                trimCollapsedText: 'więcej',
                trimExpandedText: ' mniej',
              ),
            ),
          Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
              child:
                  Text(vm.formattedDate, style: const TextStyle(fontSize: 14))),
        ],
      ),
    );
  }
}
