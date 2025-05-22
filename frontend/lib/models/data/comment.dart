import 'package:ale_okaz/models/data/reactions.dart';

class Comment {
  final String id;
  final String content;
  final DateTime createdAt;
  final DateTime? editedAt;
  final String authorId;
  final Reactions reactions;
  final List<Comment> comments;

  Comment({
    required this.id,
    required this.content,
    required this.createdAt,
    this.editedAt,
    required this.authorId,
    required this.reactions,
    required this.comments,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'] as String,
      content: json['content'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      editedAt: json['editedAt'] != null
          ? DateTime.parse(json['editedAt'] as String)
          : null,
      authorId: json['authorId'] as String,
      reactions: Reactions.fromJson(json['reactions'] as Map<String, dynamic>),
      comments: (json['comments'] as List)
          .map((e) => Comment.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
