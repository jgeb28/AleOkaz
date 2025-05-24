import 'package:camera/camera.dart';
import 'package:get/get.dart';
import 'package:ale_okaz/views/posts/create_post.dart';

class TakePictureViewModel extends GetxController {
  // List of available cameras
  final cameras = <CameraDescription>[].obs;

  // The active camera controller
  late CameraController controller;

  // Reactive flags
  final isInitialized = false.obs;
  final isFlashOn = false.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    // 1) get all cameras
    final available = await availableCameras();
    cameras.assignAll(available);

    // 2) choose a default (or injected) camera
    CameraDescription description;
    try {
      description = Get.find<CameraDescription>();
    } catch (_) {
      description = cameras.first;
    }

    // 3) initialize controller
    controller = CameraController(description, ResolutionPreset.medium);
    await controller.initialize();
    isInitialized.value = true;
  }

  Future<void> switchCamera() async {
    if (cameras.length < 2) return;

    final current = controller.description;
    // pick the other camera
    final next = cameras.firstWhere((c) => c != current);
    controller = CameraController(next, ResolutionPreset.medium);
    await controller.initialize();
    // flash resets when you switch
    isFlashOn.value = false;
  }

  Future<void> toggleFlash() async {
    if (!isInitialized.value) return;
    isFlashOn.toggle();
    await controller.setFlashMode(
      isFlashOn.value ? FlashMode.torch : FlashMode.off,
    );
  }

  Future<void> takePicture() async {
    if (!isInitialized.value) return;
    final file = await controller.takePicture();
    // navigate to create post with the image
    Get.to(() => CreatePost(imagePath: file.path));
  }

  @override
  void onClose() {
    controller.dispose();
    super.onClose();
  }
}
