import 'package:ale_okaz/screens/home.dart';
import 'package:ale_okaz/screens/posts/comments/comments_list.dart';
import 'package:ale_okaz/screens/posts/create_post.dart';
import 'package:ale_okaz/screens/posts/take_picture.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:ale_okaz/services/internet_controller.dart';

import 'package:ale_okaz/screens/profile/profile.dart';
import 'package:ale_okaz/screens/register/register.dart';
import 'package:ale_okaz/screens/login/login.dart';
import 'package:ale_okaz/screens/essentials/no_connection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final cameras = await availableCameras();

  Get.put(cameras.first, permanent: true);
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
        GetPage(name: '/take-picture', page: () => const TakePictureScreen()),
        GetPage(name: '/home', page: () => const Home()),
      ],
      home: const LoginScreen(),
    );
  }
}
