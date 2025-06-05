// lib/widgets/posts/comments_sheet.dart
import 'package:ale_okaz/views/comments/comments_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ale_okaz/consts/colors.dart';
import 'package:ale_okaz/view_models/comments/comments_sheet_view_model.dart';

void showCommentsSheet(BuildContext context, String postId) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black54,
    builder: (_) => CommentsSheet(postId: postId),
  );
}

class CommentsSheet extends StatelessWidget {
  final String postId;
  const CommentsSheet({required this.postId, super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Get.put(CommentsSheetViewModel(postId), tag: postId);

    return DraggableScrollableSheet(
      initialChildSize: 0.95,
      minChildSize: 0.3,
      maxChildSize: 0.95,
      expand: false,
      builder: (_, __) => ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        child: Container(
          color: componentColor,
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
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
                child: Text('Komentarze',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: Obx(() {
                  if (vm.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (vm.comments.isEmpty) {
                    return const Center(child: Text('Brak komentarzy'));
                  }
                  return CommentsList(
                    comments: vm.comments.reversed.toList(),
                  );
                }),
              ),
              const Divider(height: 1),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: vm.textController,
                        decoration: const InputDecoration(
                          hintText: 'Dodaj komentarz...',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    Obx(() => IconButton(
                          icon: vm.isSending.value
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child:
                                      CircularProgressIndicator(strokeWidth: 2),
                                )
                              : const Icon(Icons.send,
                                  color: buttonBackgroundColor),
                          onPressed: vm.isSending.value ? null : vm.sendComment,
                        )),
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
