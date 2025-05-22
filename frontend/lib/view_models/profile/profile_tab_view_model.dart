import 'package:ale_okaz/services/rest_service.dart';
import 'package:ale_okaz/view_models/profile/profile_view_model.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ProfileTabViewModel extends GetxController {
  final RestService _restService = RestService();
  final ProfileViewModel profileViewModel = Get.find();

  var username = ''.obs;
  var isEditing = false.obs;

  Rxn<File> image = Rxn<File>();
  final ImagePicker _picker = ImagePicker();

  Future<void> pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      image.value = File(pickedFile.path);
    }
  }

  Future<void> setImage() async {
    try {
      await _restService.updateUserInfo(imageFile: image.value);
      profileViewModel.loadUserdata();
      Get.snackbar(
        'Sukces',
        "Pomyślnie zmieniono zdjęcie profilowe",
        backgroundColor: Colors.green,
      );
    } catch (ex) {
      Get.snackbar(
        'Błąd',
        "Wystąpił błąd podczas zmiany nazwy użytkownika : $ex",
        backgroundColor: Colors.red,
      );
    }
  }

  Future<void> setUsername(String newUsername) async {
    username.value = newUsername;
    isEditing.value = false;
    try {
      await _restService.updateUserInfo(data: {'username': newUsername});
      profileViewModel.changeUsername(newUsername);
      Get.snackbar(
        'Sukces',
        "Pomyślnie zmieniono nazwę użytkownika",
        backgroundColor: Colors.green,
      );
    } catch (ex) {
      Get.snackbar(
        'Błąd',
        "Wystąpił błąd podczas zmiany nazwy użytkownika : $ex",
        backgroundColor: Colors.red,
      );
    }
  }

  void toggleEdit() {
    isEditing.value = !isEditing.value;
  }
}
