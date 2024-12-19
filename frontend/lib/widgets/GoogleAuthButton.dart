import 'package:flutter/material.dart';
import 'package:sign_in_button/sign_in_button.dart';

class GoogleAuthButton extends StatelessWidget {
  const GoogleAuthButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: SizedBox(
        width: double.maxFinite,
        height: 50,
        child: SignInButton(
          Buttons.google,
          text: "Sign up with Google",
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30), // Make it rounded
          ),
          onPressed: () {},
        ),
      ),
    );
  }
}
