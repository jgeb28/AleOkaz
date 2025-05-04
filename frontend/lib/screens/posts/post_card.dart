import 'package:ale_okaz/screens/posts/comments/comments_list.dart';
import 'package:ale_okaz/utils/colors.dart';
import 'package:ale_okaz/utils/ip.dart';
import 'package:ale_okaz/utils/post.dart';
import 'package:ale_okaz/widgets/posts/interaction_button.dart';
import 'package:ale_okaz/widgets/posts/post_top_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:readmore/readmore.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostCard extends StatefulWidget {
  final Post post;
  const PostCard({required this.post, super.key});

  @override
  State<PostCard> createState() => _PostState();
}

class _PostState extends State<PostCard> {
  late bool isLiked;

  Future<void> toggleLikeButton() async {
    setState(() {
      isLiked = !isLiked;
    });
  }

  @override
  void initState() {
    super.initState();
    isLiked = false;
    timeago.setLocaleMessages('pl', timeago.PlMessages());
  }

  String getImageId(String imageUrl) {
    List<String> splittedImageUrl = imageUrl.split('/');
    return '${splittedImageUrl[splittedImageUrl.length - 2]}/${splittedImageUrl[splittedImageUrl.length - 1]}';
  }

  String getDate() {
    final DateTime createdAt = widget.post.createdAt;
    final full = timeago.format(createdAt, locale: 'pl');

    return full;
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
          // 1) HEADER
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
                  '$ip/${getImageId(widget.post.imageUrl)}',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Row(
            children: [
              InteractionButton(
                number: 10000,
                isNumberDisplayed: true,
                icon: isLiked ? Icons.favorite : Icons.favorite_border,
                onPressed: toggleLikeButton,
              ),
              const SizedBox(width: 2),
              // comment interaction
              InteractionButton(
                number: widget.post.comments.length,
                isNumberDisplayed: true,
                icon: Icons.comment,
                onPressed: () {
                  Get.to(() => CommentsPage(comments: widget.post.comments),
                      transition: Transition.downToUp,
                      curve: Curves.easeInOut,
                      duration: Duration(milliseconds: 300));
                },
              ),
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
              child: Text(getDate(),
                  style: const TextStyle(
                    fontSize: 14,
                  )))
        ],
      ),
    );
  }
}
