import 'package:ale_okaz/utils/comments_controller.dart';
import 'package:flutter/material.dart';
import 'package:ale_okaz/screens/posts/comments/comments_list.dart';
import 'package:ale_okaz/services/post_service.dart';
import 'package:ale_okaz/utils/colors.dart';
import 'package:ale_okaz/utils/comment.dart';
import 'package:get/get.dart';

void showCommentsSheet(BuildContext context, String postId) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black54,
    builder: (_) => CommentsSheet(postId: postId),
  );
}

class CommentsSheet extends StatefulWidget {
  final String postId;
  const CommentsSheet({required this.postId, super.key});

  @override
  State<CommentsSheet> createState() => _CommentsSheetState();
}

class _CommentsSheetState extends State<CommentsSheet> {
  final TextEditingController _textController = TextEditingController();
  final commentsCountController = Get.find<CommentsCountController>();
  List<Comment> _comments = [];
  bool _loading = true;
  bool _sending = false;

  @override
  void initState() {
    super.initState();
    _loadComments();
  }

  Future<void> _loadComments() async {
    try {
      final fetched = await PostService().getComments(widget.postId);
      setState(() {
        _comments = fetched;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Błąd przy ładowaniu komentarzy: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _sendComment() async {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    setState(() => _sending = true);

    try {
      final newComment = await PostService().createComment(widget.postId, text);
      setState(() {
        _comments.add(newComment);
        _textController.clear();
      });

      commentsCountController.increment();

      await _loadComments();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Nie udało się dodać komentarza: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.95,
      minChildSize: 0.3,
      maxChildSize: 0.95,
      expand: false,
      builder: (_, __) => ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        child: Container(
          color: componentColor,
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: SizedBox(
                  width: 40,
                  height: 4,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.all(Radius.circular(2)),
                    ),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  'Komentarze',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: _loading
                    ? const Center(child: CircularProgressIndicator())
                    : _comments.isEmpty
                        ? const Center(child: Text('Brak komentarzy'))
                        : CommentsList(comments: _comments),
              ),
              const Divider(height: 1),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _textController,
                        decoration: const InputDecoration(
                          hintText: 'Dodaj komentarz...',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: _sending
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.send,
                              color: buttonBackgroundColor),
                      onPressed: _sending ? null : _sendComment,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
