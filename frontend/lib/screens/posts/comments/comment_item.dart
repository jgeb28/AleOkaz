import 'package:ale_okaz/utils/comment.dart';
import 'package:flutter/material.dart';

class CommentItem extends StatefulWidget {
  final Comment comment;
  const CommentItem({super.key, required this.comment});

  @override
  State<CommentItem> createState() => _CommentItemState();
}

class _CommentItemState extends State<CommentItem> {
  @override
  Widget build(BuildContext context) {
    return const Text('Halo');
  }
}
