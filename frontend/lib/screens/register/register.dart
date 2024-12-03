import 'package:ale_okaz/utils/colors.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        backgroundColor: primaryBackgroundColor,
        body: SafeArea(
          child: Center(
            child: Column(children: [
              // AleOkaz
              Text('AleOkaz',
                  style: TextStyle(fontSize: 48, fontFamily: 'Righteous'))
              // label for email
              // input

              // label for password
              // input

              // label for repeating password
              // input

              // button

              // a href -> login page

              // line

              // google auth
            ]),
          ),
        ));
  }
}
