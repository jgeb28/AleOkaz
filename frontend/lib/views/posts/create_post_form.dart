// lib/screens/posts/create_post_form.dart
import 'package:ale_okaz/view_models/posts/create_post_form.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ale_okaz/widgets/button.dart';
import 'package:ale_okaz/widgets/label_input.dart';

class CreatePostForm extends StatelessWidget {
  final String imagePath;
  const CreatePostForm({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    final vm = Get.put(CreatePostFormViewModel(imagePath), tag: imagePath);

    return Form(
      key: vm.formKey,
      child: Column(
        children: [
          LabelInput(
            maxLines: 2,
            labelName: "Opis",
            controller: vm.descriptionController,
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Proszę podać opis';
              }
              return null;
            },
          ),
          const SizedBox(height: 30),
          Button(
            label: "Utwórz",
            onPressed: vm.submitForm,
            width: MediaQuery.of(context).size.width / 2,
          ),
        ],
      ),
    );
  }
}
