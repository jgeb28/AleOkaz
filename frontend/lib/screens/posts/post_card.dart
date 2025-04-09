import 'package:ale_okaz/utils/post.dart';
import 'package:ale_okaz/widgets/posts/interaction_button.dart';
import 'package:flutter/material.dart';

class PostCard extends StatefulWidget {
  final Post post;
  const PostCard({required this.post, super.key});

  @override
  State<PostCard> createState() => _PostState();
}

class _PostState extends State<PostCard> {
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
    isLiked = false;
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
