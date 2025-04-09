import 'package:ale_okaz/widgets/posts/interaction_button.dart';
import 'package:flutter/material.dart';

class Post extends StatefulWidget {
  final String description;
  final bool isLiked;
  const Post({required this.isLiked, required this.description, super.key});

  @override
  State<Post> createState() => _PostState();
}

class _PostState extends State<Post> {
  final String imageUrl = "https://picsum.photos/seed/142/600";
  late bool isLiked;

  Future<void> toggleLikeButton() async {
    setState(() {
      isLiked = !isLiked;
    });
  }

  @override
  void initState() {
    super.initState();
    isLiked = widget.isLiked;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.network(imageUrl, width: double.infinity, height: 400),
        Positioned(
          right: 0,
          left: 0,
          bottom: 0,
          child: Padding(
            padding: const EdgeInsets.only(left: 8, bottom: 13),
            child: Row(
              children: [
                InteractionButton(
                  icon: isLiked ? Icons.favorite : Icons.favorite_border,
                  onPressed: toggleLikeButton,
                ),
                InteractionButton(
                  icon: Icons.share,
                  onPressed: () => {},
                ),
                const Spacer(),
                InteractionButton(
                  icon: Icons.comment,
                  onPressed: () => {},
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
