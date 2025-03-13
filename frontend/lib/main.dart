import 'package:ale_okaz/screens/profile/profile.dart';
import 'package:ale_okaz/screens/register/register.dart';
import 'package:ale_okaz/screens/login/login.dart';
import 'package:ale_okaz/screens/no_connection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ale_okaz/services/internet_controller.dart';

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
      home: Scaffold(
        appBar: AppBar(
          title: const Text('My Home Page'),
        ),
        body: Center(
          child: Builder(
            builder: (context) {
              return Column(
                children: [
                  const Text('Hello, World!'),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Get.toNamed('/register');
                    },
                    child: const Text('To register'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Get.toNamed('/login');
                    },
                    child: const Text('To login'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Get.toNamed('/profile');
                    },
                    child: const Text('To profile'),
                  ),
                  Text(username != null ? 'Welcome, $username' : ''),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
