import 'package:ale_okaz/screens/login/login.dart';
import 'package:ale_okaz/screens/register/create_user.dart';
import 'package:ale_okaz/widgets/auth_button.dart';
import 'package:ale_okaz/widgets/label_input.dart';
import 'package:ale_okaz/widgets/title_section.dart';
import 'package:flutter/material.dart';
import 'validator.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _repeatedPasswordController = TextEditingController();
  final validator = Validator();

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _repeatedPasswordController.dispose();
    super.dispose();
  }

  void clearInputs() {
    _usernameController.text = "";
    _emailController.text = "";
    _passwordController.text = "";
    _repeatedPasswordController.text = "";
  }

  void submit() async {
    if (_formKey.currentState!.validate()) {
      try {
        await createUser(_usernameController.text, _emailController.text,
            _passwordController.text);

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            backgroundColor: Colors.green,
            content: Center(child: Text('Pomyślnie utworzono konto!'))));

        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => LoginScreen()));
      } catch (e) {
        clearInputs();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            backgroundColor: Colors.red,
            content: Center(child: Text('Bład podczas tworzenia konta!'))));
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
                labelName: "Nazwa użytkownika",
                controller: _usernameController,
                validator: (String? value) {
                  return validator.validateUsername(value);
                }),
            LabelInput(
                labelName: "Email",
                controller: _emailController,
                validator: (String? value) {
                  return validator.validateEmail(value);
                }),
            LabelInput(
              labelName: "Hasło",
              controller: _passwordController,
              validator: (String? value) {
                return validator.validatePassword(value);
              },
              isObscured: true,
            ),
            LabelInput(
              labelName: "Powtórz hasło",
              controller: _repeatedPasswordController,
              validator: (String? value) {
                return validator.validateRepeatedPassword(
                    _passwordController.text, value);
              },
              isObscured: true,
            ),
            AuthButton(label: "Zarejestruj się", onPressed: submit)
          ],
        ));
  }
}
