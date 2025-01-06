import 'package:ale_okaz/screens/reset_password/change_password.dart';
import 'package:ale_okaz/services/auth_service.dart';
import 'package:ale_okaz/widgets/title_section.dart';
import 'package:ale_okaz/widgets/auth_button.dart';
import 'package:ale_okaz/widgets/label_input.dart';
import 'package:flutter/material.dart';

class ResetPasswordForm extends StatefulWidget{
  const ResetPasswordForm({super.key});

  @override
  State<ResetPasswordForm> createState() => _ResetPasswordFormState();
}

class _ResetPasswordFormState extends State<ResetPasswordForm> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  final _emailController = TextEditingController();
  final _authService = AuthService();

  @override
  void dispose() {
    _codeController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void clearInputs() {
    _codeController.text = "";
    _emailController.text = "";
  }

  void showSnackBar(e, Color color) {
    ScaffoldMessenger.of(context).showSnackBar( SnackBar(
            backgroundColor: color,
            content: Center(child: Text('$e'))));
  }

  void sendToken() async {
    if (_emailController.text == "") {
      showSnackBar("Musisz podać email", Colors.red);
    } else {
      try {
        await _authService.sendToken(_emailController.text);
      } catch (e) {
        showSnackBar('Wystąpił błąd podczas resetowania $e', Colors.red);
      }
    }
  }

  void redirectToChangePassword(String email, String token) {
    Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ChangePasswordScreen(email: email)));
  }

  void submit() async {
    if (_formKey.currentState!.validate()) {
      try {
        bool success = await _authService.verifyToken(_emailController.text, _codeController.text);
        if (success) {
          clearInputs();
          redirectToChangePassword(_emailController.text, _codeController.text);
        }
      } catch (e) {
        clearInputs();
        showSnackBar('Wystąpił błąd podczas resetowania $e', Colors.red);
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
                   return value == null ? "Wypełnij pole" : null;
                }
            ),
            TextButton(
              onPressed: sendToken,
              child: const Text(
                'Wyślij ponownie kod',
                style: TextStyle(
                  color: Color(0xFF0C4010),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            LabelInput(
                labelName: "Kod resetu",
                controller: _codeController,
                validator: (String? value) {
                   return value == null ? "Wypełnij pole" : null;
                }
            ),
            AuthButton(label: "Zatwierdź", onPressed: submit)
          ],
        )
    );
  }
}