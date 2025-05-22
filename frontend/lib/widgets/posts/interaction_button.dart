import 'package:ale_okaz/consts/colors.dart';
import 'package:flutter/material.dart';

class InteractionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final int number;
  final bool isNumberDisplayed;
  final bool isRow;
  final double iconSize;

  const InteractionButton(
      {required this.onPressed,
      required this.icon,
      super.key,
      this.number = 0,
      this.isRow = true,
      this.iconSize = 30,
      this.isNumberDisplayed = false});

  @override
  Widget build(BuildContext context) {
    return isRow
        ? Row(mainAxisSize: MainAxisSize.min, children: [
            IconButton(
                alignment: Alignment.center,
                iconSize: iconSize,
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
          ])
        : Column(children: [
            IconButton(
                alignment: Alignment.center,
                iconSize: iconSize,
                padding: EdgeInsets.zero, // remove default padding
                constraints: const BoxConstraints(
                  minWidth: 0,
                  minHeight: 0,
                ),
                onPressed: onPressed,
                icon: (Icon(icon, color: buttonBackgroundColor))),
            if (isNumberDisplayed)
              Transform.translate(
                offset: const Offset(0, -8),
                child: Text(
                  number.toString(),
                  style: const TextStyle(color: tabGreenColor),
                ),
              ),
          ]);
  }
}
