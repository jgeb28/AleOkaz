import 'package:ale_okaz/consts/colors.dart';
import 'package:ale_okaz/utils/parser.dart';
import 'package:flutter/material.dart';
import 'package:ale_okaz/models/data/post_miniature.dart';
import 'package:get/get.dart';

class PostMiniatureContainer extends StatelessWidget {
  final PostMiniature post;
  const PostMiniatureContainer({required this.post, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed('/post/${post.id}'),
      child: Stack(
        children: [
          // Network Image as Background
          Positioned.fill(
            child: Image.network(
              Parser().getImageUrl(post.imageUrl),
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: Colors.grey,
                alignment: Alignment.center,
                child: const Icon(Icons.broken_image, color: Colors.white),
              ),
            ),
          ),

          // Bottom Overlay for Info
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(8),
              color: Colors.black.withOpacity(0.6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        height: 25,
                        width: 25,
                        padding: const EdgeInsets.only(top: 2),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: offWhiteColor,
                        ),
                        child: const Icon(
                          Icons.favorite,
                          size: 18,
                          color: tabGreenColor,
                        ),
                      ),
                      const SizedBox(width: 3),
                      Text(
                        post.reactions.likes.toString(),
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
            ),
          ),
        ],
      ),
    );
  }
}
