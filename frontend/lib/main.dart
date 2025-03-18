import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:ale_okaz/services/internet_controller.dart';

import 'package:ale_okaz/screens/profile/profile.dart';
import 'package:ale_okaz/screens/register/register.dart';
import 'package:ale_okaz/screens/login/login.dart';
import 'package:ale_okaz/screens/essentials/no_connection.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(InternetController(), permanent: true);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({
    this.username,
    super.key,
  });
  final String? username;

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => const MyApp()),
        GetPage(name: '/no-connection', page: () => const NoConnectionScreen()),
        GetPage(name: '/register', page: () => const RegisterScreen()),
        GetPage(name: '/login', page: () => const LoginScreen()),
        GetPage(name: '/profile', page: () => const ProfileScreen()),

      ],
      home: const LoginScreen(),
    );
  }
}
