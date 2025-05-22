import 'package:ale_okaz/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginViewModel extends GetxController {
  final AuthService authService = AuthService();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  void submit() async {
    if (formKey.currentState!.validate()) {
      try {
        await authService.login(
          usernameController.text,
          passwordController.text,
        );
        Get.offAllNamed('/profile');
        //Get.toNamed('/profile');
      } catch (e) {
        clearInputs();
        Get.snackbar("Błąd", 'Wystąpił błąd podczas logowania $e',
            backgroundColor: Colors.red);
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
