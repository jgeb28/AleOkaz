import 'package:flutter/material.dart';

class Post extends StatelessWidget {
  final String imageUrl = "https://picsum.photos/seed/142/600";
  final String description;
  const Post({required this.description, super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.network(imageUrl, width: double.infinity, height: 400),
      ],
    );
  }
}
