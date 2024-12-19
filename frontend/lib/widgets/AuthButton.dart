import 'package:ale_okaz/utils/colors.dart';
import 'package:flutter/material.dart';

class AuthButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;

  const AuthButton({required this.label, required this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 8),
      child: SizedBox(
          width: double.maxFinite,
          height: 50,
          child: FilledButton(
              style: FilledButton.styleFrom(
                  backgroundColor: buttonBackgroundColor,
                  foregroundColor: Colors.white),
              onPressed: onPressed,
              child: Text(
                label,
                style: const TextStyle(fontSize: 20),
              ))),
    );
  }
}
