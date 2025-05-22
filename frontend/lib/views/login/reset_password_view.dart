import 'package:ale_okaz/view_models/login/reset_password_view_model.dart';
import 'package:ale_okaz/consts/colors.dart';
import 'package:ale_okaz/widgets/auth_button.dart';
import 'package:ale_okaz/widgets/title_section.dart';
import 'package:ale_okaz/widgets/label_input.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ResetPasswordView extends StatelessWidget {
  final ResetPasswordViewModel _viewModel = Get.put(ResetPasswordViewModel());

  ResetPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBackgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.15,
          ),
          child: Form(
            key: _viewModel.formKey,
            child: Column(
              children: [
                const TitleSection(name: "AleOkaz"),
                LabelInput(
                  labelName: "Hasło",
                  isObscured: true,
                  controller: _viewModel.passwordController,
                  validator: _viewModel.passwordValidator,
                ),
                LabelInput(
                  labelName: "Powtórz Hasło",
                  isObscured: true,
                  controller: _viewModel.repeatedPasswordController,
                  validator: _viewModel.repeatPasswordValidator,
                ),
                AuthButton(
                  label: "Zatwierdź",
                  onPressed: _viewModel.submit,
                ),
                TextButton(
                        onPressed: () => Get.offAllNamed('/login'),
                        child: const Text(
                          'Wróć',
                          style: TextStyle(
                            color: Color(0xFF0C4010),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}