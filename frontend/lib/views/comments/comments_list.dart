import 'package:ale_okaz/models/data/comment.dart';
import 'package:ale_okaz/view_models/comments/comments_list_view_model.dart';
import 'package:ale_okaz/views/comments/comment_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // ← add provider

class CommentsList extends StatefulWidget {
  final List<Comment> comments;
  const CommentsList({Key? key, required this.comments}) : super(key: key);

  @override
  _CommentsListState createState() => _CommentsListState();
}

class _CommentsListState extends State<CommentsList> {
  late final CommentsListViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = CommentsListViewModel(widget.comments);
  }

  @override
  void didUpdateWidget(covariant CommentsList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.comments != widget.comments) {
      _viewModel.updateComments(widget.comments);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CommentsListViewModel>.value(
      value: _viewModel,
      child: Consumer<CommentsListViewModel>(
        builder: (ctx, vm, _) {
          if (vm.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (vm.errorMessage != null) {
            return Center(child: Text('Error: ${vm.errorMessage}'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: vm.sortedComments.length,
            itemBuilder: (ctx, i) {
              final comment = vm.sortedComments[i];
              final user = vm.usersMap[comment.authorId]!;
              return CommentItem(comment: comment, user: user);
            },
          );
        },
      ),
    );
  }
}
