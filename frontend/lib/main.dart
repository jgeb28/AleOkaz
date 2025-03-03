import 'package:ale_okaz/screens/home.dart';
import 'package:ale_okaz/screens/register/register.dart';
import 'package:ale_okaz/screens/login/login.dart';
import 'package:ale_okaz/utils/camera_provider.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final cameras = await availableCameras();

  runApp(ChangeNotifierProvider(
    create: (context) => CameraProvider(cameras),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({
    this.username,
    super.key,
  });
  final String? username;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Root widget
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
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => RegisterScreen()));
                    },
                    child: const Text('To register'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const LoginScreen()));
                    },
                    child: const Text('To login'),
                  ),
                  Text(username != null ? 'Welcome, $username' : ''),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const Home()));
                      },
                      child: const Text('To home'))
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
