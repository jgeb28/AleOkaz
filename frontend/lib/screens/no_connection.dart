import 'package:ale_okaz/widgets/bottom_navbar.dart';
import 'package:flutter/material.dart';

class NoConnectionScreen extends StatelessWidget {
  const NoConnectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Brak połączenia z internetem',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
            ),),
            Text('Sprawdź swoje połączenie z internetem',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
            ),),
            ],
        ),
      ),
      bottomNavigationBar: const BottomNavbar(),
    );
  }
}