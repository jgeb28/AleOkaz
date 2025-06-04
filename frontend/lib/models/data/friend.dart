class Friend implements Comparable<Friend> {
  final String id;
  final String username;
  final String imageUrl;

  const Friend({required this.id, required this.username, required this.imageUrl});

  @override
  int compareTo(Friend other) {
    return username.compareTo(other.username);
  }
}
