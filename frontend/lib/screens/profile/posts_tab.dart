import 'package:ale_okaz/utils/post.dart';
import 'package:ale_okaz/utils/reactions.dart';
import 'package:ale_okaz/widgets/post_container.dart';
import 'package:flutter/material.dart';

class PostsTab extends StatelessWidget {
  const PostsTab({super.key});

  static List<Post> posts = [
    Post(
      id: "1",
      content: 'Beautiful lake view',
      imageUrl: 'https://example.com/lake.jpg',
      createdAt: DateTime.now(),
      authorId: 'user123',
      reactions: const Reactions(likes: 0, userReaction: null),
      location: 'Lake Tahoe',
      comments: [],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return (GridView.count(
        primary: false,
        crossAxisSpacing: 6,
        mainAxisSpacing: 6,
        crossAxisCount: 3,
        children: List.generate(posts.length, (i) {
          return PostContainer(post: posts[i]);
        })));
  }
}
