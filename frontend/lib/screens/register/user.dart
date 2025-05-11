class User {
  final String id;
  final String username;
  final String email;
  final String profilePicture;

  const User(
      {required this.id,
      required this.username,
      required this.email,
      required this.profilePicture});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json['id'] as String,
        username: json['username'] as String,
        email: json['email'] as String,
        profilePicture: json['profilePicture'] as String);
  }
}
