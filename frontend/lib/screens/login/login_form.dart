import 'package:ale_okaz/widgets/auth_button.dart';
import 'package:ale_okaz/widgets/label_input.dart';
import 'package:ale_okaz/widgets/title_section.dart';
import 'package:ale_okaz/services/auth_service.dart';
import 'package:flutter/material.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void clearInputs() {
    _emailController.text = "";
    _passwordController.text = "";
  }

  void showErrorSnackBar(e) {
    ScaffoldMessenger.of(context).showSnackBar( SnackBar(
            backgroundColor: Colors.red,
            content: Center(child: Text('Wystąpił błąd podczas logowania: $e'))));
  }

  void submit() async {
    if (_formKey.currentState!.validate()) {
      try {
        await _authService.login(_emailController.text, _passwordController.text);
      } catch (e) {
        clearInputs();
        showErrorSnackBar(e);
      }
    }
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
                validator: (String? value) {
                  if (value == null) {
                    return "Wypełnij pole";
                  }
                  final bool emailValid = 
                  RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                    .hasMatch(value);
                  if (!emailValid) {
                    return "Niepoprawny email";
                  }
                  return null; 
                }
            ),
            LabelInput(
              labelName: "Hasło",
              controller: _passwordController,
              validator: (String? value) {
                  return value == null ? "Wypełnij pole" : null;
              },
              isObscured: true,
            ),
            TextButton(
              onPressed: () {},
              child: const Text(
                'Zapomniałeś hasło?',
                style: TextStyle(
                  color: Color(0xFF0C4010),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            AuthButton(label: "Zaloguj się", onPressed: submit)
          ],
        )
    );
  }
}
