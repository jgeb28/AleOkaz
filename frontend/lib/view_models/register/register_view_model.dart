import 'package:ale_okaz/models/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterViewModel extends GetxController {

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final AuthService authService = AuthService();
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final repeatedPasswordController = TextEditingController();

  var isLoading = false.obs;


  @override
  void onClose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    repeatedPasswordController.dispose();
    super.onClose();
  }

  void clearInputs() {
    usernameController.clear();
    emailController.clear();
    passwordController.clear();
    repeatedPasswordController.clear();
  }

  Future<void> submit() async {
    if (formKey.currentState!.validate()) {
      isLoading.value = true;

      try {
        await authService.createUser(
          usernameController.text,
          emailController.text,
          passwordController.text,
        );

        Get.snackbar('Sukces', 'Pomyślnie utworzono konto!',
            backgroundColor: Colors.green, colorText: Colors.white);

        Get.offAllNamed('/login');
      } catch (e) {
        clearInputs();
        Get.snackbar('Błąd',"Błąd podczas tworzenia konta! $e",
            backgroundColor: Colors.red, colorText: Colors.white);
      } finally {
        isLoading.value = false;
      }
    }
  }
}
