import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ale_okaz/services/auth_service.dart';

class ProfileController extends GetxController {
  final AuthService _authService = AuthService();
  
  var username = RxnString();
  var isMyProfile = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadUsername();
  }

  Future<void> _loadUsername() async {
    username.value = Get.parameters['username']; 
    if (username.value == null) {
      final prefs = await SharedPreferences.getInstance();
      String? name = prefs.getString('username');
      if (name == null) {
        Get.offAllNamed('/login');
      } else {
        isMyProfile.value = true;
        username.value = name;
      }
    }
  }

  Future<void> addFriend() async {
    try {
      await _authService.sendPOSTRequest(
        'http://10.0.2.2:8080/api/friends/add',
        {'username': username.value},
      );
      Get.snackbar("Sukces", "Pomyślnie dodano znajomego",
          backgroundColor: Colors.green, colorText: Colors.white);
    } catch (ex) {
      Get.snackbar("Błąd", ex.toString(),
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }
}