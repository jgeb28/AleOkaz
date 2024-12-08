import 'package:ale_okaz/screens/login/login.dart';
import 'package:ale_okaz/screens/register/register_form.dart';
import 'package:ale_okaz/utils/colors.dart';
import 'package:ale_okaz/widgets/GoogleAuthButton.dart';
import 'package:ale_okaz/widgets/line_divider.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();

  void onPressed(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
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
                    const RegisterForm(),
                    FilledButton(
                        style: FilledButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            foregroundColor: smallTextColor),
                        onPressed: () => onPressed(context),
                        child: const Text("Posiadam już konto",
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    const LineDivider(),
                    const GoogleAuthButton()
                  ],
                ),
              )),
        ));
  }
}
