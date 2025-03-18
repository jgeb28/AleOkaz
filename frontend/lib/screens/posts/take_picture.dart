import 'package:ale_okaz/utils/colors.dart';
import 'package:ale_okaz/widgets/bottom_bar.dart';
import 'package:ale_okaz/widgets/top_bar/top_bar.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({super.key});

  @override
  State<TakePictureScreen> createState() => _TakePictureScreenState();
}

class _TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();

    CameraDescription cameraDescription = Get.find<CameraDescription>();

    _controller = CameraController(
      cameraDescription,
      ResolutionPreset.medium,
    );

    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBackgroundColor,
      appBar: const TopBar(
        hasBackButton: true,
      ),
      bottomNavigationBar: const BottomBar(),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: CameraPreview(_controller)),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(15.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(50.0),
          child: SizedBox(
            width: 70,
            height: 70,
            child: FloatingActionButton(
              backgroundColor: buttonBackgroundColor,
              child: const Icon(Icons.circle,
                  size: 60, color: primaryBackgroundColor),
              onPressed: () async {
                try {
                  await _initializeControllerFuture;

                  final image = await _controller.takePicture();
                } catch (e) {
                  print(e);
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
