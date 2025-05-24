import 'package:camera/camera.dart';
import 'package:get/get.dart';

class CameraService extends GetxService {
  final List<CameraDescription> cameras;
  CameraController? _controller;
  var isFlashOn = false.obs;
  var isLoading = true.obs;
  var isInitialized = false.obs;

  CameraService(this.cameras);

  CameraController get controller {
    if (_controller == null) {
      throw Exception(
          "CameraController not initialized. Call initialize() first.");
    }
    return _controller!;
  }

  Future<void> toggleFlash() async {
    if (_controller == null || !_controller!.value.isInitialized) return;

    try {
      // Front cameras typically don't support flash
      if (_controller!.description.lensDirection == CameraLensDirection.front) {
        Get.snackbar("Notice", "Flash not available on front camera");
        return;
      }

      isFlashOn.value = !isFlashOn.value;
      await _controller!
          .setFlashMode(isFlashOn.value ? FlashMode.torch : FlashMode.off);
    } catch (e) {
      isFlashOn.value = !isFlashOn.value; // Revert on error
      Get.snackbar("Error", "Could not toggle flash");
    }
  }

  Future<String> takePicture() async {
    if (!isInitialized.value || _controller == null) {
      throw Exception("Camera not initialized");
    }

    try {
      final XFile image = await _controller!.takePicture();
      return image.path;
    } catch (e) {
      Get.snackbar("Error", "Failed to take picture");
      rethrow;
    }
  }

  Future<void> initialize() async {
    try {
      isLoading.value = true;
      _controller = CameraController(cameras.first, ResolutionPreset.medium);
      await _controller!.initialize();
      isInitialized.value = true;
    } catch (e) {
      _controller?.dispose();
      _controller = null;
      isInitialized.value = false;
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> switchCamera() async {
    if (cameras.length < 2) return;

    try {
      isLoading.value = true;
      final currentIndex = cameras.indexOf(controller.description);
      final newIndex = (currentIndex + 1) % cameras.length;

      await _controller?.dispose();
      _controller =
          CameraController(cameras[newIndex], ResolutionPreset.medium);
      await _controller!.initialize();

      // Turn off flash when switching to front camera
      if (cameras[newIndex].lensDirection == CameraLensDirection.front) {
        await _controller!.setFlashMode(FlashMode.off);
        isFlashOn.value = false;
      }
    } catch (e) {
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    _controller?.dispose();
    super.onClose();
  }
}
