import 'package:ale_okaz/screens/layout.dart';
import 'package:ale_okaz/screens/posts/comments/comment_item.dart';
import 'package:ale_okaz/utils/comment.dart';
import 'package:flutter/material.dart';

class CommentsPage extends StatelessWidget {
  final List<Comment> comments;
  const CommentsPage({super.key, required this.comments});

  @override
  Widget build(BuildContext context) {
    return const Layout(
        hasBackButton: true, hasBottomBar: false, body: Text('halo'));
  }
}
