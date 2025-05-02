import 'dart:io';

import 'package:ale_okaz/utils/colors.dart';
import 'package:ale_okaz/utils/ip.dart';
import 'package:ale_okaz/utils/post.dart';
import 'package:ale_okaz/widgets/posts/interaction_button.dart';
import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';

class PostCard extends StatefulWidget {
  final Post post;
  const PostCard({required this.post, super.key});

  @override
  State<PostCard> createState() => _PostState();
}

class _PostState extends State<PostCard> {
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

  String getImageId(String imageUrl) {
    List<String> splittedImageUrl = imageUrl.split('/');
    return '${splittedImageUrl[splittedImageUrl.length - 2]}/${splittedImageUrl[splittedImageUrl.length - 1]}';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: componentColor,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1) HEADER
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                // avatar
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(''),
                  // or AssetImage if local, or placeholder
                ),
                const SizedBox(width: 8),
                // name + maybe timestamp
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.post.authorId.toString(),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Stack(
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.5,
                ),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      '$ip/${getImageId(widget.post.imageUrl)}',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
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
                        onPressed: () {},
                      ),
                      const Spacer(),
                      InteractionButton(
                        icon: Icons.comment,
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
              child: ReadMoreText(
                style: const TextStyle(fontSize: 15),
                widget.post.content,
                trimMode: TrimMode.Line,
                trimLines: 2,
                trimCollapsedText: 'pokaż więcej',
                trimExpandedText: ' pokaż mniej',
              )),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: TextField(
              decoration: InputDecoration(
                  border: const UnderlineInputBorder(),
                  hintText: 'Dodaj komentarz...',
                  suffixIcon: IconButton(
                      onPressed: () {}, icon: const Icon(Icons.send))),
            ),
          )
        ],
      ),
    );
  }
}
