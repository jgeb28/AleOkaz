import 'package:flutter/material.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'package:get/get.dart';


import 'package:ale_okaz/utils/colors.dart';
import 'package:ale_okaz/screens/login/login_form.dart';
import 'package:ale_okaz/widgets/line_divider.dart';


class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

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
                    const LoginForm(),
                    Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 8),
                      child: TextButton(
                        onPressed: () {
                          Get.toNamed('/register');
                        },
                        child: const Text(
                          'Stwórz nowe konto',
                          style: TextStyle(
                            color: Color(0xFF0C4010), // Set link color
                            fontWeight:
                                FontWeight.bold, // Underline text like a link
                          ),
                        ),
                      ),
                    ),
                    const LineDivider(),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: SizedBox(
                        width: double.maxFinite,
                        height: 50,
                        child: SignInButton(
                          Buttons.google,
                          text: "Sign up with Google",
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(30), // Make it rounded
                          ),
                          onPressed: () {},
                        ),
                      ),
                    ),
                  ],
              ),
          ),
        ));
  }
}
