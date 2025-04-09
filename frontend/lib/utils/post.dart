class Post {
  final String id;
  final String content;
  final String imageUrl;
  final DateTime createdAt;
  final String authorId;
  final int likes;
  final String location;

  const Post(
      {required this.id,
      required this.content,
      required this.imageUrl,
      required this.createdAt,
      required this.authorId,
      required this.likes,
      required this.location});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'] as String,
      content: json['content'] as String,
      imageUrl: json['imageUrl'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      authorId: json['authorId'] as String,
      likes: json['likes'] as int? ?? 0,
      location: json['location'] as String? ?? 'Unknown',
    );
  }
}
