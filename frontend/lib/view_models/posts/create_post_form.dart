import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ale_okaz/services/post_service.dart';
import 'package:ale_okaz/services/rest_service.dart';

class CreatePostFormViewModel extends GetxController {
  final String imagePath;
  CreatePostFormViewModel(this.imagePath);

  final formKey = GlobalKey<FormState>();
  final descriptionController = TextEditingController();

  final _postService = PostService();
  final _restService = RestService(); // ✅ Inject your secure REST service

  final fishingSpots = <Map<String, dynamic>>[].obs;
  late final selectedSpot = Rxn<String>();

  @override
  void onInit() {
    super.onInit();
    fetchFishingSpots();
  }

  @override
  void onClose() {
    descriptionController.dispose();
    super.onClose();
  }

  Future<void> fetchFishingSpots() async {
    try {
      final spots =
          await _restService.sendGETRequest<List<Map<String, dynamic>>>(
        'api/fishingspots/all',
        (json) {
          if (json is List) {
            return json.cast<Map<String, dynamic>>();
          } else {
            throw Exception("Nieprawidłowy format odpowiedzi");
          }
        },
      );

      fishingSpots.assignAll(spots);
      print(spots);
      if (spots.isNotEmpty) {
        selectedSpot.value =
            spots[0]['id'] as String?; // Safely access 'id' and set the value
      }
    } catch (e) {
      Get.snackbar(
        'Błąd',
        'Nie udało się pobrać miejsc połowu: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> submitForm() async {
    if (!formKey.currentState!.validate()) return;

    if (selectedSpot.value == null) {
      Get.snackbar(
        'Błąd',
        'Wybierz miejsce połowu',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      final response = await _postService.createPost(
        "api/posts",
        descriptionController.text,
        imagePath,
        selectedSpot.value ?? '', // 🔁 Update PostService to accept this
      );

      if (response['error'] == true) {
        Get.snackbar(
          'Błąd',
          response['message'],
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        Get.snackbar(
          'Sukces',
          'Post został utworzony',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
        Get.offNamed('/home');
      }
    } catch (e) {
      Get.snackbar(
        'Błąd',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
