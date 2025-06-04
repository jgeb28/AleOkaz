import 'package:ale_okaz/models/data/comment.dart';
import 'package:ale_okaz/models/data/reactions.dart';

class Post {
  final String id;
  final String content;
  final String imageUrl;
  final DateTime createdAt;
  final DateTime? editedAt;
  final String authorId;
  final Reactions reactions;
  final List<Comment> comments;
  final String location;

  const Post({
    required this.id,
    required this.content,
    required this.imageUrl,
    required this.createdAt,
    this.editedAt,
    required this.authorId,
    required this.reactions,
    required this.comments,
    this.location = '',
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'] as String,
      content: json['content'] as String,
      imageUrl: json['imageUrl'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      editedAt: json['editedAt'] != null
          ? DateTime.parse(json['editedAt'] as String)
          : null,
      authorId: json['authorId'] as String,
      reactions: Reactions.fromJson(json['reactions'] as Map<String, dynamic>?),
      comments: (json['comments'] as List<dynamic>)
          .map((e) => Comment.fromJson(e as Map<String, dynamic>))
          .toList(),
      location: json['location'] as String? ?? 'Jezioro Zegrzyńskie',
    );
  }
}
