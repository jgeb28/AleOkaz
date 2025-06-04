import 'package:ale_okaz/views/essentials/no_connection_view.dart';
import 'package:ale_okaz/views/login/login_view.dart';
import 'package:ale_okaz/views/posts/posts_screen.dart';
import 'package:ale_okaz/views/posts/take_picture.dart';
import 'package:ale_okaz/views/profile/profile_view.dart';
import 'package:ale_okaz/views/register/register_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ale_okaz/views/posts/post_screen.dart';

import 'package:ale_okaz/services/connectivity_service.dart';
import 'package:timeago/timeago.dart' as timeago;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  timeago.setLocaleMessages('pl', timeago.PlMessages());
  Get.put(ConnectivityService(), permanent: true);
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
      initialRoute: '/login',
      getPages: [
        GetPage(name: '/', page: () => const MyApp()),
        GetPage(name: '/no-connection', page: () => const NoConnectionScreen()),
        GetPage(name: '/register', page: () => RegisterScreen()),
        GetPage(name: '/login', page: () => const LoginScreen()),
        GetPage(name: '/profile', page: () => const ProfileScreen()),
        GetPage(name: '/take-picture', page: () => const TakePictureScreen()),
        GetPage(name: '/home', page: () => const PostsScreen()),
        GetPage(name: '/profile/:userId', page: () => const ProfileScreen()),
        GetPage(name: '/post/:postId', page: () => const PostScreen()),
      ],
    );
  }
}
