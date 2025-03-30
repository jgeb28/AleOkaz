import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ale_okaz/models/services/rest_service.dart';

class ProfileViewModel extends GetxController {
  final RestService _restService = RestService();

  var isMyProfile = false.obs;
  var username = "".obs;

  @override
  void onInit() {
    super.onInit();

    loadUsername(); 
  }

  Future<void> loadUsername() async {
    String? paramUsername = Get.parameters['username'];

    if (paramUsername != null) {
      username.value = paramUsername; 
      isMyProfile.value = false; // It's not the logged-in user
    } else {
      final prefs = await SharedPreferences.getInstance();
      final storedUsername = prefs.getString('username');

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
        'http://10.0.2.2:8080/api/friends/add',
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
}
