class Post {
  final String id;
  final String content;
  final String imageUrl;
  final DateTime createdAt;
  final String authorId;

  const Post(
      {required this.id,
      required this.content,
      required this.imageUrl,
      required this.createdAt,
      required this.authorId});

  factory Post.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'id': String id,
        'content': String content,
        'imageUrl': String imageUrl,
        'createdAt': DateTime createdAt,
        'authorId': String authorId
      } =>
        Post(
            id: id,
            content: content,
            imageUrl: imageUrl,
            createdAt: createdAt,
            authorId: authorId),
      _ => throw const FormatException('Failed to load post.'),
    };
  }
}
