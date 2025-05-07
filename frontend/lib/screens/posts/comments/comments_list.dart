import 'package:flutter/material.dart';
import 'package:ale_okaz/utils/colors.dart';
import 'package:ale_okaz/utils/comment.dart';
import 'package:ale_okaz/screens/posts/comments/comment_item.dart';

class CommentsPage extends StatelessWidget {
  final List<Comment> comments;
  const CommentsPage({super.key, required this.comments});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: componentColor,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Align(
                alignment: Alignment.center,
                child: IconButton(
                  icon: const Icon(Icons.arrow_downward, color: Colors.black),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                itemCount: comments.length,
                itemBuilder: (BuildContext context, int index) {
                  final comment = comments[index];
                  return CommentItem(comment: comment);
                },
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider(height: 1),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
