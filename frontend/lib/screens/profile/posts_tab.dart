import 'package:ale_okaz/utils/post.dart';
import 'package:ale_okaz/widgets/post_container.dart';
import 'package:flutter/material.dart';

class PostsTab extends StatelessWidget {
  const PostsTab({
    required this.isMyProfile,
    super.key});

  final bool isMyProfile;

  static List<Post> posts = 
  [
    Post(likes: 12, location: 'Jezioro'),
    Post(likes: 2, location: 'Jezioro2'),
    Post(likes: 2, location: 'Jezioro2'),
    Post(likes: 2, location: 'Jezioro2'),
    Post(likes: 2, location: 'Jezioro2'),
    Post(likes: 2, location: 'Jezioro2'),
    Post(likes: 2, location: 'Jezioro2'),
    Post(likes: 2, location: 'Jezioro2'),
    Post(likes: 2, location: 'Jezioro2'),
    Post(likes: 2, location: 'Jezioro2'),
    Post(likes: 2, location: 'Jezioro2'),
    Post(likes: 2, location: 'Jezioro2'),
    Post(likes: 2, location: 'Jezioro2'),
    Post(likes: 2, location: 'Jezioro2'),
    Post(likes: 2, location: 'Jezioro2'),
    Post(likes: 2, location: 'Jezioro2'),
    Post(likes: 2, location: 'Jezioro2'),
    Post(likes: 2, location: 'Jezioro2'),
    Post(likes: 2, location: 'Jezioro2'),
    Post(likes: 2, location: 'Jezioro2'),
    Post(likes: 2, location: 'Jezioro2'),
    Post(likes: 2, location: 'Jezioro2'),
  ];
  
  @override
  Widget build(BuildContext context) {
    return (
      GridView.count(
        primary: false,
        crossAxisSpacing: 6,
        mainAxisSpacing: 6,
        crossAxisCount: 3,
        children: List.generate(posts.length, (i) {
          return PostContainer(post: posts[i]);
        })
      )
    );    
  }
}