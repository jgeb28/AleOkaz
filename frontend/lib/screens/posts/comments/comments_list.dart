import 'package:ale_okaz/screens/layout.dart';
import 'package:ale_okaz/screens/posts/comments/comment_item.dart';
import 'package:ale_okaz/utils/colors.dart';
import 'package:ale_okaz/utils/comment.dart';
import 'package:flutter/material.dart';

class CommentsPage extends StatelessWidget {
  final List<Comment> comments;
  const CommentsPage({super.key, required this.comments});

  @override
  Widget build(BuildContext context) {
    return Layout(
        hasBackButton: true,
        hasBottomBar: false,
        body: Container(
          color: componentColor,
          child: ListView.separated(
              itemBuilder: (BuildContext context, int index) =>
                  const SizedBox(height: 50, child: Text('comment')),
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(),
              itemCount: comments.length),
        ));
  }
}
