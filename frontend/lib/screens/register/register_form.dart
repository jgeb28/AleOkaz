import 'package:ale_okaz/widgets/AuthButton.dart';
import 'package:ale_okaz/widgets/label_input.dart';
import 'package:ale_okaz/widgets/title_section.dart';
import 'package:flutter/material.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _repeatedPasswordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _repeatedPasswordController.dispose();
    super.dispose();
  }

  void submit() {
    if (_formKey.currentState!.validate()) {}
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
          children: [
            const TitleSection(name: "AleOkaz"),
            LabelInput(
              labelName: "Email",
              controller: _emailController,
            ),
            LabelInput(
              labelName: "Hasło",
              controller: _passwordController,
            ),
            LabelInput(
                labelName: "Powtórz hasło",
                controller: _repeatedPasswordController),
            AuthButton(label: "Zarejestruj się", onPressed: submit)
          ],
        ));
  }
}
