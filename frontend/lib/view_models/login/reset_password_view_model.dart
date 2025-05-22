import 'package:ale_okaz/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ResetPasswordViewModel extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final passwordController = TextEditingController();
  final repeatedPasswordController = TextEditingController();
  final AuthService _authService = AuthService();
  String email = Get.arguments as String;

  String? passwordValidator(String? value) {
    return value == null || value.isEmpty ? "Wypełnij pole" : null;
  }

  String? repeatPasswordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "Wypełnij pole";
    }
    if (value != passwordController.text) {
      return "Hasła nie są takie same";
    }
    return null;
  }

  void submit() async {
    if (formKey.currentState!.validate()) {
      try {
        await _authService.changePassword(email, passwordController.text);
        clearInputs();
        Get.offAllNamed('/login');
        showSnackBar("Pomyślnie zresetowano hasło", Colors.green);
      } catch (e) {
        clearInputs();
        showSnackBar("Wystąpił błąd podczas resetowania: $e", Colors.red);
      }
    }
  }

  void clearInputs() {
    passwordController.clear();
    repeatedPasswordController.clear();
  }

  void showSnackBar(String message, Color color) {
    Get.snackbar(
      "Status",
      message,
      backgroundColor: color,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(8),
    );
  }

  @override
  void onClose() {
    passwordController.dispose();
    repeatedPasswordController.dispose();
    super.onClose();
  }
}
