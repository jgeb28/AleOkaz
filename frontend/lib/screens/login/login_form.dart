import 'package:ale_okaz/screens/reset_password/reset_password.dart';
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
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void clearInputs() {
    _usernameController.text = "";
    _passwordController.text = "";
  }

  void showSnackBar(e, Color color) {
    ScaffoldMessenger.of(context).showSnackBar( SnackBar(
            backgroundColor: color,
            content: Center(child: Text('$e'))));
  }

  void submit() async {
    if (_formKey.currentState!.validate()) {
      try {
        await _authService.login(_usernameController.text, _passwordController.text);
        showSnackBar("Zalogowano Pomyślnie", Colors.green);
      } catch (e) {
        clearInputs();
        showSnackBar('Wystąpił błąd podczas logowania: $e', Colors.red);
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
                labelName: "Nazwa Użytkownika",
                controller: _usernameController,
                validator: (String? value) {
                   return value == null ? "Wypełnij pole" : null;
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
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const ResetPasswordScreen()));
              },
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
