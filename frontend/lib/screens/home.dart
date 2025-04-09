import 'package:ale_okaz/screens/layout.dart';
import 'package:ale_okaz/services/post_service.dart';
import 'package:ale_okaz/utils/colors.dart';
import 'package:ale_okaz/widgets/bottom_bar.dart';
import 'package:ale_okaz/widgets/top_bar/top_bar.dart';
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
        body: ListView(
      padding: const EdgeInsets.all(8),
      children: [],
    ));
  }
}
