import 'package:ale_okaz/services/post_service.dart';
import 'package:ale_okaz/widgets/button.dart';
import 'package:ale_okaz/widgets/label_input.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreatePostForm extends StatefulWidget {
  final String imagePath;
  const CreatePostForm({required this.imagePath, super.key});

  @override
  CreatePostFormState createState() => CreatePostFormState();
}

class CreatePostFormState extends State<CreatePostForm> {
  final _formKey = GlobalKey<FormState>();
  final _locationController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _postService = PostService();

  @override
  void dispose() {
    _locationController.dispose();
    _descriptionController.dispose();

    super.dispose();
  }

  void showSnackBar(e, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(backgroundColor: color, content: Center(child: Text('$e'))));
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        var response = await _postService.createPost(
            "api/posts", _descriptionController.text, widget.imagePath);

        if (response['error'] == true) {
          showSnackBar("Error: ${response['message']}", Colors.red);
        } else {
          showSnackBar("Created post", Colors.green);
          Get.toNamed('/home');
        }
      } catch (e) {
        showSnackBar("Error: ${e}", Colors.red);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // Location Field
          // LabelInput(
          //   labelName: "Lokalizacja",
          //   controller: _locationController,
          //   validator: (String? value) {
          //     if (value == null || value.isEmpty) {
          //       return 'Proszę podać lokalizację';
          //     }
          //     return null;
          //   },
          // ),
          // const SizedBox(height: 20),
          LabelInput(
              maxLines: 2,
              labelName: "Opis",
              controller: _descriptionController,
              validator: (String? description) => null),
          const SizedBox(height: 30),

          Button(
              label: "Utwórz",
              onPressed: _submitForm,
              width: MediaQuery.sizeOf(context).width / 2)
        ],
      ),
    );
  }
}
