import 'package:ale_okaz/view_models/profile/friends_tab_view_model.dart';
import 'package:ale_okaz/view_models/profile/profile_tab_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:ale_okaz/models/services/connectivity_service.dart';
import 'package:ale_okaz/view_models/profile/profile_view_model.dart';

import 'package:ale_okaz/views/profile/profile_view.dart';
import 'package:ale_okaz/views/register/register_view.dart';
import 'package:ale_okaz/views/login/login_view.dart';
import 'package:ale_okaz/views/essentials/no_connection_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => const MyApp()),
        GetPage(name: '/no-connection', page: () => const NoConnectionScreen()),
        GetPage(name: '/register', page: () => RegisterScreen()),
        GetPage(name: '/login', page: () => LoginScreen()),
        GetPage(name: '/profile', page: () => ProfileScreen()),
        GetPage(name: '/profile/:username', page: () => ProfileScreen())
        

      ],
      home: LoginScreen(),
    );
  }
}