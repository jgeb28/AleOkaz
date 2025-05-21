import 'package:ale_okaz/screens/layout.dart';
import 'package:ale_okaz/services/post_service.dart';
import 'package:ale_okaz/screens/posts/post_card.dart';
import 'package:flutter/material.dart';
import 'package:ale_okaz/utils/post.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Future<List<Post>> futurePosts;
  final PostService _postService = PostService();

  @override
  void initState() {
    super.initState();
    futurePosts = _postService.getPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
        body: FutureBuilder<List<Post>>(
            future: futurePosts,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<Post> posts = snapshot.data!;
                return ListView(
                    padding: const EdgeInsets.all(8),
                    children: posts
                        .map((post) =>
                            PostCard(key: ValueKey(post.id), post: post))
                        .toList());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No posts available'));
              }

              return const Center(child: CircularProgressIndicator());
            }));
  }
}
