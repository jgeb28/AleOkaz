import 'dart:io';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ImageController extends GetxController {
static ImageController get to => Get.find<ImageController>();
    Rxn<File> image = Rxn<File>();
    final ImagePicker _picker = ImagePicker();

    Future<void> pickImage() async {
      final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        image.value = File(pickedFile.path);
      }
    }
}
