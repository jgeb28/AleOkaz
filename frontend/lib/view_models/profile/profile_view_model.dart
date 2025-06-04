import 'package:ale_okaz/consts/flutter_api_consts.dart';
import 'package:ale_okaz/services/rest_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ale_okaz/services/auth_service.dart';

class ProfileViewModel extends GetxController {
  final RestService _restService = RestService();
  final AuthService _authService = AuthService();

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
    String? paramUserId = Get.parameters['userId'];
    print(paramUserId);

    if (paramUserId != null) {
      try {
        var response = await _restService.sendGETRequest(
            "api/users/info/$paramUserId", (decodedJson) => decodedJson);
        username.value = response['username'];
        String url = response['profilePicture'];
        // Tymczasowe rozwiązanie LOCALHOST ma problem na emulatorze
        String address = url.substring(22);
        profilePictureUrl.value = "${FlutterApiConsts.baseUrl}/$address";
      } catch (ex) {
        Get.snackbar(
          'Błąd',
          " : $ex",
          backgroundColor: Colors.red,
        );
      }

      isMyProfile.value = false;
    } else {
      final prefs = await SharedPreferences.getInstance();
      final storedUsername = prefs.getString('username');
      try {
        var response = await _restService.sendGETRequest<Map<String, dynamic>>(
            "api/users/info/5dea42da-b3ec-4b48-bf45-e773bc84ab50",
            (decodedJson) => decodedJson as Map<String, dynamic>);

        userId.value = response['id'];

        String url = response['profilePicture'];
        String address = url.substring(22);
        profilePictureUrl.value = "${FlutterApiConsts.baseUrl}/$address";
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
        isMyProfile.value = true; // It's the logged-in user's profile
      }
    }
  }

  Future<void> logout() async {
    await _authService.clearTokens();
    Get.offAllNamed('/login');
  }

  Future<void> addFriend() async {
    try {
      await _restService.sendPOSTRequest('api/friends/add',
          payload: {'username': username.value}, parser: (decodedJson) => {});

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
