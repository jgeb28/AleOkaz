import 'package:ale_okaz/screens/posts/display_picture.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreatePost extends StatelessWidget {
  final String imagePath;

  const CreatePost({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: DisplayPicture(imagePath: imagePath));
  }
}
