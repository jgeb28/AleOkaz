import 'package:ale_okaz/view_models/posts/take_picture_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:camera/camera.dart';
import 'package:ale_okaz/views/layout.dart';
import 'package:ale_okaz/consts/colors.dart';

class TakePictureScreen extends StatelessWidget {
  const TakePictureScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // instantiate & provide the ViewModel
    final vm = Get.put(TakePictureViewModel());

    return Layout(
      body: Scaffold(
        body: Obx(() {
          if (vm.isInitialized.value) {
            return Padding(
              padding: const EdgeInsets.all(8),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CameraPreview(vm.controller),
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        }),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Obx(() {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Flash toggle
              IconButton(
                iconSize: 30,
                icon:
                    Icon(vm.isFlashOn.value ? Icons.flash_on : Icons.flash_off),
                color: buttonBackgroundColor,
                onPressed: vm.toggleFlash,
              ),

              // Capture button
              ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: SizedBox(
                  width: 70,
                  height: 70,
                  child: FloatingActionButton(
                    backgroundColor: buttonBackgroundColor,
                    onPressed: vm.takePicture,
                    child: const Icon(Icons.circle,
                        size: 60, color: primaryBackgroundColor),
                  ),
                ),
              ),

              // Switch camera
              IconButton(
                iconSize: 30,
                icon: const Icon(Icons.cameraswitch_outlined),
                color: buttonBackgroundColor,
                onPressed: vm.switchCamera,
              ),
            ],
          );
        }),
      ),
    );
  }
}
