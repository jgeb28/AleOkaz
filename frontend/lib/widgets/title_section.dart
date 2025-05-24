import 'package:flutter/material.dart';

class TitleSection extends StatelessWidget {
  final double fontSize;
  final String name;
  final String? fontFamily;

  const TitleSection(
      {super.key,
      required this.name,
      this.fontSize = 48,
      this.fontFamily = 'Righteous'});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              name,
              style: TextStyle(
                fontFamily: 'Righteous',
                fontSize: fontSize,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
