import 'package:ale_okaz/widgets/auth_button.dart';
import 'package:ale_okaz/widgets/button.dart';
import 'package:ale_okaz/widgets/label_input.dart';
import 'package:flutter/material.dart';

class CreatePostForm extends StatefulWidget {
  const CreatePostForm({super.key});

  @override
  CreatePostFormState createState() => CreatePostFormState();
}

class CreatePostFormState extends State<CreatePostForm> {
  final _formKey = GlobalKey<FormState>();
  final _locationController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _locationController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {}
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
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

          // Description Field
          LabelInput(
            labelName: "Opis",
            controller: _descriptionController,
            validator: (String? value) {
              return null;
            },
          ),
          const SizedBox(height: 30),

          // Submit Button
          Button(label: "Utwórz", onPressed: _submitForm, width: 200)
        ],
      ),
    );
  }
}
