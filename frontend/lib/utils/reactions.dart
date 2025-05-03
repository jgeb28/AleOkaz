class Reactions {
  final int likes;

  const Reactions({
    required this.likes,
  });

  factory Reactions.fromJson(Map<String, dynamic>? json) {
    return Reactions(
      likes: (json?['likes'] as int?) ?? 0,
    );
  }
}
