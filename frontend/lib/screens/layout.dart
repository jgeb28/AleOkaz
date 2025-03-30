import 'package:ale_okaz/utils/colors.dart';
import 'package:ale_okaz/widgets/bottom_bar.dart';
import 'package:ale_okaz/widgets/top_bar/top_bar.dart';
import 'package:flutter/material.dart';

class Layout extends StatelessWidget {
  final Widget body;
  final bool hasBackButton;
  const Layout({super.key, required this.body, this.hasBackButton = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBackgroundColor,
      appBar: TopBar(hasBackButton: hasBackButton),
      body: body,
      bottomNavigationBar: const BottomBar(),
    );
  }
}
