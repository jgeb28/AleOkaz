class User {
  final String id;
  final String username;
  final String email;
  final String profilePictureUrl;

  const User(
      {required this.id,
      required this.username,
      required this.email,
      required this.profilePictureUrl});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json['id'] as String,
        username: json['username'] as String,
        email: json['email'] as String,
        profilePictureUrl: json['profilePicture'] as String);
  }
}
