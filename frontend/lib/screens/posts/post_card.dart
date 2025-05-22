import 'package:ale_okaz/services/post_service.dart';
import 'package:ale_okaz/consts/colors.dart';
import 'package:ale_okaz/utils/comments_controller.dart';
import 'package:ale_okaz/models/data/post.dart';
import 'package:ale_okaz/utils/parser.dart';
import 'package:ale_okaz/widgets/posts/comments_sheet.dart';
import 'package:ale_okaz/widgets/posts/interaction_button.dart';
import 'package:ale_okaz/widgets/posts/post_top_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:readmore/readmore.dart';

class PostCard extends StatefulWidget {
  final Post post;
  const PostCard({required this.post, super.key});

  @override
  State<PostCard> createState() => _PostState();
}

class _PostState extends State<PostCard> {
  late bool isLiked;
  late int likesCount;
  final _parser = Parser();
  final commentsCountController = Get.put(CommentsCountController());

  Future<void> toggleLikeButton() async {
    setState(() {
      isLiked = !isLiked;
      likesCount += isLiked ? 1 : -1;
    });

    final String postId = widget.post.id;

    if (isLiked) {
      final success = await PostService().setReaction(postId);
      if (!success) {
        setState(() {
          isLiked = !isLiked;
          likesCount += isLiked ? 1 : -1;
        });
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            backgroundColor: Colors.red,
            content: Center(child: Text("Couldn't add reaction to the post"))));
      }
    } else {
      final success = await PostService().deleteReaction(postId);

      if (!success) {
        setState(() {
          isLiked = !isLiked;
          likesCount += isLiked ? 1 : -1;
        });
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            backgroundColor: Colors.red,
            content:
                Center(child: Text("Couldn't remove reaction from the post"))));
      }
    }
  }

  @override
  void initState() {
    super.initState();
    likesCount = widget.post.reactions.likes;
    isLiked = widget.post.reactions.userReaction != null ? true : false;

    commentsCountController.initCount(widget.post.comments.length);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: componentColor,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PostTopBar(
            userId: widget.post.authorId,
            location: widget.post.location,
          ),
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.5,
            ),
            child: AspectRatio(
              aspectRatio: 1,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  _parser.getImageUrl(widget.post.imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Row(
            children: [
              InteractionButton(
                number: likesCount,
                isNumberDisplayed: true,
                icon: isLiked ? Icons.favorite : Icons.favorite_border,
                onPressed: toggleLikeButton,
              ),
              const SizedBox(width: 2),
              Obx(() => InteractionButton(
                    key: ValueKey('comment_btn_${widget.post.id}'),
                    number: commentsCountController.count.value,
                    isNumberDisplayed: true,
                    icon: Icons.comment,
                    onPressed: () => showCommentsSheet(context, widget.post.id),
                  )),
              const Spacer(),
              InteractionButton(
                icon: Icons.share,
                onPressed: () {},
              ),
            ],
          ),
          if (widget.post.content != '')
            Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                child: ReadMoreText(
                  style: const TextStyle(fontSize: 16),
                  widget.post.content,
                  trimMode: TrimMode.Line,
                  trimLines: 2,
                  trimCollapsedText: 'więcej',
                  trimExpandedText: ' mniej',
                )),
          Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
              child: Text(_parser.getDateInPL(widget.post.createdAt),
                  style: const TextStyle(
                    fontSize: 14,
                  )))
        ],
      ),
    );
  }
}
