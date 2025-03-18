import 'package:ale_okaz/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:ale_okaz/utils/post.dart';

class PostContainer extends StatelessWidget {
  final Post post;
  const PostContainer({required this.post, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('TO DO: Przejście do POSTA')));
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        color: Colors.teal[500],
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: 25,
                      width: 25,
                      padding: EdgeInsets.only(top: 2),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black,
                      ),
                      child: const Icon(
                        Icons.favorite,
                        size: 18,
                        color: tabGreenColor,
                      ),
                    ),
                    const SizedBox(width: 3),
                    Text(
                      post.likes.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                Text(
                  post.location,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
