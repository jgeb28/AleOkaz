import 'package:ale_okaz/utils/colors.dart';
import 'package:flutter/material.dart';

class InteractionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  const InteractionButton(
      {required this.onPressed, required this.icon, super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
        alignment: Alignment.center,
        iconSize: 30,
        onPressed: onPressed,
        icon: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: buttonBackgroundColor)));
  }
}
