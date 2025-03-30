import 'package:ale_okaz/utils/validator.dart';
import 'package:ale_okaz/view_models/register/register_view_model.dart';
import 'package:ale_okaz/utils/colors.dart';
import 'package:ale_okaz/widgets/auth_button.dart';
import 'package:ale_okaz/widgets/label_input.dart';
import 'package:ale_okaz/widgets/title_section.dart';
import 'package:get/get.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'package:ale_okaz/widgets/line_divider.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatelessWidget {

  RegisterScreen({super.key});

  final validator = Validator();

  @override
  Widget build(BuildContext context) {
    final RegisterViewModel viewModel = Get.put(RegisterViewModel());
    final horizonalMargin = MediaQuery.of(context).size.width * 0.15;
    final verticalMargin = MediaQuery.of(context).size.height * 0;

    return Scaffold(
        backgroundColor: primaryBackgroundColor,
        body: SingleChildScrollView(
          child: Container(
              margin: EdgeInsets.symmetric(
                  horizontal: horizonalMargin, vertical: verticalMargin),
              child: Center(
                child: Column(
                  children: [
                    Form(
                      key: viewModel.formKey,
                      child: Column(
                        children: [
                          const TitleSection(name: "AleOkaz"),
                          LabelInput(
                            labelName: "Nazwa użytkownika",
                            controller: viewModel.usernameController,
                            validator: (value) =>
                                validator.validateUsername(value),
                          ),
                          LabelInput(
                            labelName: "Email",
                            controller: viewModel.emailController,
                            validator: (value) =>
                                validator.validateEmail(value),
                          ),
                          LabelInput(
                            labelName: "Hasło",
                            controller: viewModel.passwordController,
                            validator: (value) =>
                                validator.validatePassword(value),
                            isObscured: true,
                          ),
                          LabelInput(
                            labelName: "Powtórz hasło",
                            controller: viewModel.repeatedPasswordController,
                            validator: (value) =>
                                validator.validateRepeatedPassword(
                                    viewModel.passwordController.text, value),
                            isObscured: true,
                          ),
                          Obx(() => viewModel.isLoading.value
                              ? const CircularProgressIndicator()
                              : AuthButton(
                                  label: "Zarejestruj się",
                                  onPressed: viewModel.submit)),
                        ],
                      ),
                    ),
                    FilledButton(
                        style: FilledButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            foregroundColor: smallTextColor),
                        onPressed: () => Get.offAllNamed('/login'),
                        child: const Text("Posiadam już konto",
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    const LineDivider(),
                    SignInButton(
                      Buttons.google,
                      text: "Sign up with Google",
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(30), // Make it rounded
                      ),
                      onPressed: () {},
                    ),
                  ],
                ),
              )),
        ));
  }
}
