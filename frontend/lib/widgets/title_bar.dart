import 'package:ale_okaz/consts/colors.dart';
import 'package:flutter/material.dart';

class TitleBar extends StatelessWidget {
  const TitleBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: null,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(8),
          bottomRight: Radius.circular(8),
        )
      ),
      backgroundColor: offWhiteColor,
      title: const Text('AleOkaz',
      style: TextStyle(
        fontFamily: 'Righteous',
        fontSize: 48,
      ),),
    );
  }
}