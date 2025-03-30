import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ale_okaz/models/services/auth_service.dart';

class LoginViewModel extends GetxController {
  final AuthService authService = AuthService(); 

  LoginViewModel({required this.formKey}); // Accept form key as an argument

  final GlobalKey<FormState> formKey; 
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  void submit() async {
    if (formKey.currentState!.validate()) {
      try {
        await authService.login(
          usernameController.text,
          passwordController.text,
        );
        //Get.offAllNamed('/profile');
        Get.toNamed('/profile');
      } catch (e) {
        clearInputs();
        //Get.snackbar("Błąd", 'Wystąpił błąd podczas logowania',backgroundColor: Colors.red);
      }
    }
  }

  void clearInputs() {
    usernameController.clear();
    passwordController.clear();
  }

  @override
  void onClose() {
    usernameController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
