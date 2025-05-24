import 'package:ale_okaz/services/auth_service.dart';
import 'package:ale_okaz/views/login/reset_password_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RequestPasswordResetViewModel extends GetxController {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final codeController = TextEditingController();
  final AuthService _authService = AuthService();
  var showCodeInput = false.obs;

  String? emailValidator(String? value) {
    return value == null || value.isEmpty ? "Wypełnij pole" : null;
  }

  String? codeValidator(String? value) {
    return value == null || value.isEmpty ? "Wypełnij pole" : null;
  }

  void sendToken() async {
    if (emailController.text.isEmpty) {
      showSnackBar("Musisz podać email", Colors.red);
    } else {
      try {
        await _authService.sendResetToken(emailController.text);
        showCodeInput.value = true;
        showSnackBar("Kod wysłany pomyślnie", Colors.green);
      } catch (e) {
        showSnackBar("Wystąpił błąd podczas resetowania: $e", Colors.red);
      }
    }
  }

  void submit() async {
    if (formKey.currentState!.validate()) {
      try {
        bool success = await _authService.verifyResetToken(
            emailController.text, codeController.text);
        if (success) {
          Get.to(() => ResetPasswordView(), arguments: emailController.text);
        }
      } catch (e) {
        showSnackBar("Wystąpił błąd podczas resetowania: $e", Colors.red);
      }
    }
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
    emailController.dispose();
    codeController.dispose();
    super.onClose();
  }
}
