import 'package:get/get.dart';

class ProfileTabViewModel extends GetxController {
  var username = ''.obs;
  var isEditing = false.obs;

  void setUsername(String newUsername) {
    username.value = newUsername;
    isEditing.value = false;
    // TODO: Save the new username to API or local storage.
  }

  void toggleEdit() {
    isEditing.value = !isEditing.value;
  }
}
