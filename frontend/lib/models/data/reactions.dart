class Reactions {
  final int likes;
  final String? userReaction;

  const Reactions({required this.likes, required this.userReaction});

  factory Reactions.fromJson(Map<String, dynamic>? json) {
    return Reactions(
      userReaction: json?['userReaction'] as String?,
      likes: (json?['likes'] as int?) ?? 0,
    );
  }
}