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
          Obx(
            () => DropdownButtonFormField<String>(
              value: vm.selectedSpot.value,
              decoration: InputDecoration(
                labelText: 'Wybierz miejsce połowu',
                prefixIcon: const Icon(Icons.location_on,
                    color: Colors.green), // The location icon
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              hint: const Text('Wybierz miejsce'),
              isExpanded: true,
              items: vm.fishingSpots.map((spot) {
                return DropdownMenuItem<String>(
                  value:
                      spot['id'] as String, // Ensure 'id' is treated as String
                  child:
                      Text(spot['name'] as String), // Ensure 'name' is String
                );
              }).toList(),
              onChanged: (String? newValue) {
                vm.selectedSpot.value = newValue;
              },
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Proszę wybrać miejsce połowu';
                }
                return null;
              },
            ),
          ),
          const SizedBox(height: 20), // R
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
          const SizedBox(height: 20), // Reduced spacing for dropdown
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
