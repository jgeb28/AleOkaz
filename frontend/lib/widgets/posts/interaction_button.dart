import 'package:ale_okaz/utils/colors.dart';
import 'package:flutter/material.dart';

class InteractionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final int number;
  final bool isNumberDisplayed;
  const InteractionButton(
      {required this.onPressed,
      required this.icon,
      super.key,
      this.number = 0,
      this.isNumberDisplayed = false});

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      IconButton(
          alignment: Alignment.center,
          iconSize: 30,
          padding: EdgeInsets.zero, // remove default padding
          constraints: const BoxConstraints(
            minWidth: 0,
            minHeight: 0,
          ),
          onPressed: onPressed,
          icon: (Icon(icon, color: buttonBackgroundColor))),
      if (isNumberDisplayed)
        Transform.translate(
          offset: const Offset(-4, 0),
          child: Text(
            number.toString(),
            style: const TextStyle(color: tabGreenColor),
          ),
        ),
    ]);
  }
}
