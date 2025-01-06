import 'package:ale_okaz/screens/reset_password/change_password_form.dart';
import 'package:ale_okaz/utils/colors.dart';
import 'package:flutter/material.dart';

class ChangePasswordScreen extends StatelessWidget {
  final String email;
  const ChangePasswordScreen({super.key, required this.email});

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
                child: Column(
                  children: [
                    ChangePasswordForm(email: email),
                  ],
              ),
          ),
        ));
  }
}