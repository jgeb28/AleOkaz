import 'package:ale_okaz/utils/colors.dart';
import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;
  final double width;

  // todo: add custom width that user can provide, default to double.maxFinite
  // add icon support

  const Button({
    required this.label,
    required this.onPressed,
    this.width = double.maxFinite,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 8),
      child: SizedBox(
          width: 100,
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
