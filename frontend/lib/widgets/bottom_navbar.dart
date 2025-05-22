
import 'package:flutter/material.dart';
import 'package:ale_okaz/consts/colors.dart';

class BottomNavbar extends StatelessWidget {
  const BottomNavbar({super.key});


  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20), // Adjust as needed
          topRight: Radius.circular(20),
        ),
        child: BottomNavigationBar(
          backgroundColor: offWhiteColor,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          items: const <BottomNavigationBarItem> [
            BottomNavigationBarItem(
              icon: Icon(Icons.location_on_outlined, 
                color: buttonBackgroundColor,
                size: 24.0,),
              label: ''),
            BottomNavigationBarItem(
              icon: Icon(Icons.camera_alt_outlined,
              color: buttonBackgroundColor,
                size: 24.0,),
              label: ''),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline, 
              color: buttonBackgroundColor,
                size: 24.0,),
              label: ''),

    ]));
  }

}