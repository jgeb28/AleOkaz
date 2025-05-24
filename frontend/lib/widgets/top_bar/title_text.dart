import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TitleText extends StatelessWidget {
  final String fontFamily;
  final double fontSize;
  const TitleText(
      {super.key, this.fontFamily = 'Righteous', this.fontSize = 24});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => Get.toNamed('/home'),
      child: Text('AleOkaz',
          style: TextStyle(
              fontFamily: fontFamily, fontSize: fontSize, color: Colors.black)),
    );
  }
}
