import 'package:ale_okaz/views/login/request_password_reset_view.dart';
import 'package:flutter/material.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'package:get/get.dart';

import 'package:ale_okaz/view_models/login/login_view_model.dart';

import 'package:ale_okaz/widgets/auth_button.dart';
import 'package:ale_okaz/widgets/label_input.dart';
import 'package:ale_okaz/widgets/title_section.dart';
import 'package:ale_okaz/consts/colors.dart';
import 'package:ale_okaz/widgets/line_divider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final LoginViewModel loginViewModel = Get.put(LoginViewModel());
    final horizonalMargin = MediaQuery.of(context).size.width * 0.15;
    final verticalMargin = MediaQuery.of(context).size.width * 0.05;
    return Scaffold(
      backgroundColor: primaryBackgroundColor,
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(
              horizontal: horizonalMargin, vertical: verticalMargin),
          child: Column(
            children: [
              Form(
                key: loginViewModel.formKey,
                child: Column(
                  children: [
                    const TitleSection(name: "AleOkaz"),
                    LabelInput(
                      labelName: "Nazwa Użytkownika",
                      controller: loginViewModel.usernameController,
                      validator: (value) => value == null || value.isEmpty
                          ? "Wypełnij pole"
                          : null,
                    ),
                    LabelInput(
                      labelName: "Hasło",
                      controller: loginViewModel.passwordController,
                      validator: (value) => value == null || value.isEmpty
                          ? "Wypełnij pole"
                          : null,
                      isObscured: true,
                    ),
                    TextButton(
                      onPressed: () {
                        Get.offAll(() => RequestPasswordResetView());
                      }, // Implement password reset logic
                      child: const Text(
                        'Zapomniałeś hasło?',
                        style: TextStyle(
                          color: Color(0xFF0C4010),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    AuthButton(
                        label: "Zaloguj się", onPressed: loginViewModel.submit),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 8),
                child: TextButton(
                  onPressed: () {
                    Get.offAllNamed('/register');
                  },
                  child: const Text(
                    'Stwórz nowe konto',
                    style: TextStyle(
                      color: Color(0xFF0C4010),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const LineDivider(),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: SizedBox(
                  width: double.maxFinite,
                  height: 50,
                  child: SignInButton(
                    Buttons.google,
                    text: "Sign up with Google",
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    onPressed: () {}, // Implement Google Sign-In
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
