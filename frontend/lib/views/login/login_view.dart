import 'package:flutter/material.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'package:get/get.dart';

import 'package:ale_okaz/view_models/login/login_view_model.dart';

import 'package:ale_okaz/widgets/auth_button.dart';
import 'package:ale_okaz/widgets/label_input.dart';
import 'package:ale_okaz/widgets/title_section.dart';
import 'package:ale_okaz/utils/colors.dart';
import 'package:ale_okaz/widgets/line_divider.dart';




class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  

  @override
  Widget build(BuildContext context) {
    final LoginViewModel loginViewModel = Get.put(LoginViewModel(formKey: _formKey));
    final horizonalMargin = MediaQuery.of(context).size.width * 0.15;

    return Scaffold(
      backgroundColor: primaryBackgroundColor,
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: horizonalMargin),
          child: Column(
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    const TitleSection(name: "AleOkaz"),
                    LabelInput(
                      labelName: "Nazwa Użytkownika",
                      controller: loginViewModel.usernameController,
                      validator: (value) =>
                          value == null || value.isEmpty ? "Wypełnij pole" : null,
                    ),
                    LabelInput(
                      labelName: "Hasło",
                      controller: loginViewModel.passwordController,
                      validator: (value) =>
                          value == null || value.isEmpty ? "Wypełnij pole" : null,
                      isObscured: true,
                    ),
                    TextButton(
                      onPressed: () {}, // Implement password reset logic
                      child: const Text(
                        'Zapomniałeś hasło?',
                        style: TextStyle(
                          color: Color(0xFF0C4010),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    AuthButton(label: "Zaloguj się", onPressed: loginViewModel.submit),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 8),
                child: TextButton(
                  onPressed: () {
                    Get.toNamed('/register');
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
