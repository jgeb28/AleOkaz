import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ale_okaz/models/services/rest_service.dart';

class ProfileViewModel extends GetxController {
  final RestService _restService = RestService();

  var isMyProfile = false.obs;
  var username = "".obs;
  var profilePictureUrl = "".obs;
  var userId = "".obs;

  @override
  void onInit() {
    super.onInit();

    loadUserdata(); 
  }

  Future<void> loadUserdata() async {
    String? paramUsername = Get.parameters['username'];

    if (paramUsername != null) {
      username.value = paramUsername; 
      // TO DO var response = _restService.sendGETRequest("/users/info/{id}");

      isMyProfile.value = false; // It's not the logged-in user
    } else {
      final prefs = await SharedPreferences.getInstance();
      final storedUsername = prefs.getString('username');
      try {
        var response = await _restService.sendGETRequest("/users/info/16850b20-56a6-4799-9573-c0ce12df23d6");
        userId.value = response['id'];
        // Tymczasowe rozwiązanie LOCALHOST ma problem na emulatorze
        String url = response['profilePicture'];
        String address = url.substring(22);
        profilePictureUrl.value = "http://10.0.2.2:8080/$address";
      } catch (ex) {
        Get.snackbar(
          'Błąd', 
          " : $ex",
          backgroundColor: Colors.red,
        );
      }

      if (storedUsername == null) {
        Get.offAllNamed('/login'); 
      } else {
        username.value = storedUsername;  
        isMyProfile.value = true;  // It's the logged-in user's profile
      }
    }
  }

  Future<void> addFriend() async {
    try {
      await _restService.sendPOSTRequest(
        '/friends/add',
        {'username': username.value},
      );
      Get.snackbar(
        'Sukces', 
        'Pomyślnie dodano znajomego',
        backgroundColor: Colors.green,
      );
    } catch (ex) {
      Get.snackbar(
        'Błąd', 
        "Coś poszło nie tak w trakcie dodawania znajomego : $ex",
        backgroundColor: Colors.red,
      );
    }
  }

  Future<void> changeUsername(String newUsername) async {
    username.value = newUsername;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', newUsername);
  }


}
