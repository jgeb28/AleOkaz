class Friend implements Comparable<Friend> {
  final String id;
  final String username;

  const Friend({required this.id, required this.username});

  @override
  int compareTo(Friend other) {
    return username.compareTo(other.username);
  }
}
