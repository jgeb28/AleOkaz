import 'package:ale_okaz/screens/register/user.dart';
import 'package:ale_okaz/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:ale_okaz/utils/colors.dart';
import 'package:ale_okaz/utils/comment.dart';
import 'package:ale_okaz/screens/posts/comments/comment_item.dart';

class CommentsList extends StatefulWidget {
  final List<Comment> comments;
  const CommentsList({super.key, required this.comments});

  @override
  _CommentsListState createState() => _CommentsListState();
}

class _CommentsListState extends State<CommentsList> {
  final UserService _userService = UserService();
  late final List<Comment> _sortedComments;
  late final Future<Map<String, User>> _usersMapFuture;

  @override
  void initState() {
    super.initState();

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

        if (snap.hasError) return Center(child: Text('Error: ${snap.error}'));

        final usersMap = snap.data!;
        return ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: _sortedComments.length,
          itemBuilder: (ctx, i) {
            final comment = _sortedComments[i];
            final user = usersMap[comment.authorId]!;
            return CommentItem(comment: comment, user: user);
          },
        );
      },
    );
  }
}
