import 'package:ale_okaz/utils/colors.dart';
import 'package:ale_okaz/widgets/bottom_bar.dart';
import 'package:ale_okaz/widgets/top_bar/top_bar.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: primaryBackgroundColor,
      appBar: TopBar(
        hasBackButton: true,
      ),
      bottomNavigationBar: BottomBar(),
    );
  }
}
