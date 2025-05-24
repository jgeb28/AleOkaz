import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreatePostViewModel extends GetxController {
  final String imagePath;
  CreatePostViewModel(this.imagePath);

  File get imageFile => File(imagePath);

  void showFullScreenImage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: Center(
            child: InteractiveViewer(
              panEnabled: true,
              minScale: 0.5,
              maxScale: 3.0,
              child: Image.file(File(imagePath)),
            ),
          ),
        ),
      ),
    );
  }
}
