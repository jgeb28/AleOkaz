class User {
  final String id;
  final String username;
  final String email;

  const User({required this.id, required this.username, required this.email});

  factory User.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {'id': String id, 'username': String username, 'email': String email} =>
        User(id: id, username: username, email: email),
      _ => throw const FormatException('Failed to load user'),
    };
  }
}
