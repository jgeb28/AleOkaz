// lib/screens/posts/comments/comments_list.dart

import 'package:ale_okaz/models/data/user.dart';
import 'package:flutter/material.dart';
import 'package:ale_okaz/services/user_service.dart';
import 'package:ale_okaz/models/data/comment.dart';
import 'package:ale_okaz/screens/posts/comments/comment_item.dart';

class CommentsList extends StatefulWidget {
  final List<Comment> comments;
  const CommentsList({super.key, required this.comments});

  @override
  _CommentsListState createState() => _CommentsListState();
}

class _CommentsListState extends State<CommentsList> {
  final _userService = UserService();
  late List<Comment> _sortedComments;
  late Future<Map<String, User>> _usersMapFuture;

  @override
  void initState() {
    super.initState();
    _prepareComments();
  }

  @override
  void didUpdateWidget(covariant CommentsList old) {
    super.didUpdateWidget(old);
    if (old.comments != widget.comments) {
      _prepareComments();
      setState(() {}); // trigger FutureBuilder update
    }
  }

  void _prepareComments() {
    _sortedComments = [...widget.comments]
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    final ids = _sortedComments.map((c) => c.authorId).toSet();
    _usersMapFuture = Future.wait(
      ids.map((id) => _userService.getUserInfo(id)),
    ).then((usersList) => Map.fromIterables(ids, usersList));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, User>>(
      future: _usersMapFuture,
      builder: (ctx, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snap.hasError) {
          return Center(child: Text('Error: ${snap.error}'));
        }
        final usersMap = snap.data!;
        return ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: _sortedComments.length,
          itemBuilder: (ctx, i) {
            final c = _sortedComments[i];
            final u = usersMap[c.authorId]!;
            return CommentItem(comment: c, user: u);
          },
        );
      },
    );
  }
}
