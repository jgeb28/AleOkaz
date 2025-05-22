
import 'package:ale_okaz/models/data/reactions.dart';

class PostMiniature {
  final String id;
  final String imageUrl;
  final String authorId;
  final Reactions reactions;
  final String location;

  const PostMiniature({
    required this.id,
    required this.imageUrl,
    required this.authorId,
    required this.reactions,
    this.location = '',
  });

  factory PostMiniature.fromJson(Map<String, dynamic> json) {
    return PostMiniature(
      id: json['id'] as String,
      imageUrl: json['imageUrl'] as String,
      authorId: json['authorId'] as String,
      reactions: Reactions.fromJson(json['reactions'] as Map<String, dynamic>?),
      location: json['location'] as String? ?? 'Unknown',
    );
  }
}