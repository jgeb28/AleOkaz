import 'package:ale_okaz/view_models/posts/create_post_view_model.dart';
import 'package:ale_okaz/views/posts/create_post_form.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ale_okaz/views/layout.dart';
import 'package:ale_okaz/consts/colors.dart';

class CreatePost extends StatelessWidget {
  final String imagePath;
  const CreatePost({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    final vm = Get.put(CreatePostViewModel(imagePath), tag: imagePath);

    return Layout(
      hasBackButton: true,
      body: Scaffold(
        backgroundColor: primaryBackgroundColor,
        body: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () => vm.showFullScreenImage(context),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(context).size.height * 0.5,
                        ),
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              vm.imageFile,
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
          ),
        ),
      ),
    );
  }
}
