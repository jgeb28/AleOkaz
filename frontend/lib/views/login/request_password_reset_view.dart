import 'package:ale_okaz/view_models/login/request_password_reset_view_model.dart';
import 'package:ale_okaz/consts/colors.dart';
import 'package:ale_okaz/widgets/auth_button.dart';
import 'package:ale_okaz/widgets/title_section.dart';
import 'package:ale_okaz/widgets/label_input.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RequestPasswordResetView extends StatelessWidget {
  final RequestPasswordResetViewModel _viewModel = Get.put(RequestPasswordResetViewModel());

  RequestPasswordResetView({super.key});

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
                  labelName: "Email",
                  controller: _viewModel.emailController,
                  validator: _viewModel.emailValidator,
                ),
                Obx(() => _viewModel.showCodeInput.value ? Column(
                  children: [
                    LabelInput(
                      labelName: "Kod resetu",
                      controller: _viewModel.codeController,
                      validator: _viewModel.codeValidator,
                    ),
                    TextButton(
                      onPressed: _viewModel.sendToken,
                      child: const Text(
                        'Wyślij ponownie kod',
                        style: TextStyle(
                          color: Color(0xFF0C4010),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ) : Container()),
                Obx(() => AuthButton(
                  label: _viewModel.showCodeInput.value ? "Zatwierdź" : "Wyślij kod",
                  onPressed: _viewModel.showCodeInput.value ? _viewModel.submit : _viewModel.sendToken,
                )),
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