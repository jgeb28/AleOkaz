import 'package:ale_okaz/screens/login/login.dart';
import 'package:ale_okaz/services/auth_service.dart';
import 'package:ale_okaz/widgets/title_section.dart';
import 'package:ale_okaz/widgets/auth_button.dart';
import 'package:ale_okaz/widgets/label_input.dart';
import 'package:flutter/material.dart';

class ChangePasswordForm extends StatefulWidget{
  final String email;
  const ChangePasswordForm({super.key, required this.email});

  @override
  State<ChangePasswordForm> createState() => _ChangePasswordFormState();
}

class _ChangePasswordFormState extends State<ChangePasswordForm> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _repeatedPasswordController = TextEditingController();
  final _authService = AuthService();

  @override
  void dispose() {
    _passwordController.dispose();
    _repeatedPasswordController.dispose();
    super.dispose();
  }

  void clearInputs() {
    _passwordController.text = "";
    _repeatedPasswordController.text = "";
  }

  void showSnackBar(e, Color color) {
    ScaffoldMessenger.of(context).showSnackBar( SnackBar(
            backgroundColor: color,
            content: Center(child: Text('$e'))));
  }

  void redirectToLogin() {
    Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const LoginScreen()));
  }

  void submit() async {
    if (_formKey.currentState!.validate()) {
      try {
        final email = widget.email;
        await _authService.changePassword(email, _passwordController.text);
        clearInputs();
        redirectToLogin();
        showSnackBar("Zresetowano Pomyślnie", Colors.green);
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
                labelName: "Hasło",
                isObscured: true,
                controller: _passwordController,
                validator: (String? value) {
                   return value == null ? "Wypełnij pole" : null;
                }
            ),
            LabelInput(
                labelName: "Powtórz Hasło",
                isObscured: true,
                controller: _repeatedPasswordController,
                validator: (String? value) {
                   if(value == null) {
                    return "Wypełnij pole";
                   }
                   else if(value != _passwordController.text) {
                    return "Hasła nie są takie same";
                   }
                   return null;
                }
            ),
            AuthButton(label: "Zatwierdź", onPressed: submit)
          ],
        )
    );
  }
}