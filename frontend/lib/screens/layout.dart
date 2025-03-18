import 'package:ale_okaz/utils/colors.dart';
import 'package:ale_okaz/widgets/bottom_bar.dart';
import 'package:ale_okaz/widgets/top_bar/top_bar.dart';
import 'package:flutter/material.dart';

class Layout extends StatelessWidget {
  final Widget body;
  const Layout({super.key, required this.body});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBackgroundColor,
      appBar: const TopBar(), // Your custom TopBar
      body: body, // Dynamic content passed from each screen
      bottomNavigationBar: const BottomBar(), // Your custom BottomBar
    );
  }
}
