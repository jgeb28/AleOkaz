import 'package:flutter/material.dart';
import 'package:ale_okaz/utils/colors.dart';
import 'package:ale_okaz/utils/comment.dart';
import 'package:ale_okaz/screens/posts/comments/comment_item.dart';

class CommentsList extends StatelessWidget {
  final List<Comment> comments;
  const CommentsList({super.key, required this.comments});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      itemCount: comments.length,
      itemBuilder: (BuildContext context, int index) {
        final comment = comments[index];
        return CommentItem(comment: comment);
      },
      separatorBuilder: (BuildContext context, int index) =>
          const Divider(height: 1),
    );
  }
}
