import 'package:ale_okaz/screens/register/user.dart';
import 'package:ale_okaz/services/post_service.dart';
import 'package:ale_okaz/utils/comment.dart';
import 'package:ale_okaz/utils/parser.dart';
import 'package:ale_okaz/widgets/posts/interaction_button.dart';
import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';

class CommentItem extends StatefulWidget {
  final Comment comment;
  final User user;

  CommentItem({super.key, required this.comment, required this.user});

  @override
  State<CommentItem> createState() => _CommentItemState();
}

class _CommentItemState extends State<CommentItem> {
  final _parser = Parser();
  late bool isLiked;
  late int likesCount;

  Future<void> toggleLikeButton() async {
    setState(() {
      isLiked = !isLiked;
      likesCount += isLiked ? 1 : -1;
    });

    if (isLiked) {
      final success = await PostService().setCommentReaction(widget.comment.id);
      if (!success) {
        setState(() {
          isLiked = !isLiked;
          likesCount += isLiked ? 1 : -1;
        });
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            backgroundColor: Colors.red,
            content:
                Center(child: Text("Couldn't add reaction to the comment"))));
      }
    } else {
      final success =
          await PostService().deleteCommentReaction(widget.comment.id);

      if (!success) {
        setState(() {
          isLiked = !isLiked;
          likesCount += isLiked ? 1 : -1;
        });
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            backgroundColor: Colors.red,
            content: Center(
                child: Text("Couldn't remove reaction from the comment"))));
      }
    }
  }

  @override
  void initState() {
    super.initState();
    likesCount = widget.comment.reactions.likes;
    isLiked = widget.comment.reactions.userReaction != null ? true : false;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundImage:
                NetworkImage(_parser.getImageUrl(widget.user.profilePicture)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(
                children: [
                  Text(widget.user.username,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(width: 12),
                  Text(_parser.getDateInPL(widget.comment.createdAt),
                      style: const TextStyle(color: Colors.grey))
                ],
              ),
              ReadMoreText(
                widget.comment.content,
                trimLines: 2, // show 2 lines before trimming
                trimMode: TrimMode.Line, // trim by line count
                trimCollapsedText: 'więcej',
                trimExpandedText: ' mniej',
                style: const TextStyle(fontSize: 14),
              ),
            ]),
          ),
          Column(
            children: [
              InteractionButton(
                number: likesCount,
                isNumberDisplayed: true,
                isRow: false,
                onPressed: toggleLikeButton,
                icon: isLiked ? Icons.favorite : Icons.favorite_border,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
