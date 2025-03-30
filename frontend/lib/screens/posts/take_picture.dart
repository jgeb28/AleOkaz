import 'package:ale_okaz/screens/layout.dart';
import 'package:ale_okaz/screens/posts/create_post.dart';
import 'package:ale_okaz/utils/colors.dart';
import 'package:ale_okaz/widgets/bottom_bar.dart';
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
  bool _isFlashOn = false;
  List<CameraDescription> _cameras = [];

  void switchCamera() async {
    if (_cameras.length < 2) return;

    final lensDirection = _controller.description.lensDirection;

    if (lensDirection == CameraLensDirection.front) {
      setState(() {
        _controller = CameraController(_cameras.first, ResolutionPreset.medium);
        _isFlashOn = false;
      });
    } else {
      setState(() {
        _controller = CameraController(_cameras.last, ResolutionPreset.medium);
        _isFlashOn = false;
      });
    }

    _initializeControllerFuture = _controller.initialize();
  }

  void toggleFlashlight() {
    if (!_controller.value.isInitialized) return;

    setState(() {
      _isFlashOn = !_isFlashOn;
    });

    _controller.setFlashMode(
      _isFlashOn ? FlashMode.torch : FlashMode.off,
    );
  }

  Future<void> _initializeCamera() async {
    _cameras = await availableCameras();
    CameraDescription cameraDescription = Get.find<CameraDescription>();

    _controller = CameraController(
      cameraDescription,
      ResolutionPreset.medium,
    );

    _initializeControllerFuture = _controller.initialize();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      body: Scaffold(
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
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
                iconSize: 40,
                onPressed: toggleFlashlight,
                icon: Icon(_isFlashOn ? Icons.flash_on : Icons.flash_off),
                color: buttonBackgroundColor),
            ClipRRect(
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

                      Get.to(() => CreatePost(
                            imagePath: image.path,
                          ));
                    } catch (e) {
                      print(e);
                    }
                  },
                ),
              ),
            ),
            IconButton(
                iconSize: 40,
                onPressed: switchCamera,
                icon: const Icon(Icons.cameraswitch_outlined,
                    color: buttonBackgroundColor))
          ],
        ),
      ),
    );
  }
}
