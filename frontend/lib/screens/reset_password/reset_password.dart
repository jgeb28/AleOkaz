import 'package:ale_okaz/screens/reset_password/reset_password_form.dart';
import 'package:ale_okaz/utils/colors.dart';
import 'package:flutter/material.dart';

class ResetPasswordScreen extends StatelessWidget {
  
  const ResetPasswordScreen({super.key});

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
                child: const Column(
                  children: [
                    ResetPasswordForm(),
                  ],
              ),
          ),
        ));
  }
}