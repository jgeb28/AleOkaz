import 'package:ale_okaz/screens/layout.dart';
import 'package:ale_okaz/utils/colors.dart';
import 'package:ale_okaz/widgets/bottom_bar.dart';
import 'package:ale_okaz/widgets/top_bar/top_bar.dart';
import 'package:flutter/material.dart';

import 'posts/post.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  static List<Post> posts = [
    const Post(
      description: "Lorem ipsum",
      isLiked: true,
    ),
    const Post(
      description: "Lorem ipsum",
      isLiked: false,
    ),
    const Post(
      description: "Lorem ipsum",
      isLiked: true,
    ),
    const Post(
      description: "Lorem ipsum",
      isLiked: true,
    ),
    const Post(
      description: "Lorem ipsum",
      isLiked: true,
    ),
    const Post(
      description: "Lorem ipsum",
      isLiked: true,
    ),
    const Post(
      description: "Lorem ipsum",
      isLiked: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Layout(
        body: ListView(
      padding: const EdgeInsets.all(8),
      children: posts,
    ));
  }
}
