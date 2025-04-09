import 'dart:io';
import 'package:ale_okaz/screens/layout.dart';
import 'package:ale_okaz/screens/posts/create_post_form.dart';
import 'package:ale_okaz/utils/colors.dart';
import 'package:flutter/material.dart';

class CreatePost extends StatelessWidget {
  final String imagePath;

  const CreatePost({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Layout(
      hasBackButton: true,
      body: Scaffold(
        backgroundColor: primaryBackgroundColor,
        body: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: () => _showFullScreenImage(context),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxHeight: MediaQuery.of(context).size.height * 0.5,
                          ),
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.file(
                                File(imagePath),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      CreatePostForm(imagePath: imagePath),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _showFullScreenImage(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Scaffold(
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
        ));
  }
}
