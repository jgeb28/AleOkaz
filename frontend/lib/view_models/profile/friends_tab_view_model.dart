import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:ale_okaz/models/services/rest_service.dart';

class FriendsTabViewModel extends GetxController {
  final RestService _restService = RestService();

  var friendsList = <String>[].obs;
  var filteredFriendsList = <String>[].obs;
  var searchQuery = ''.obs;
  var currentSortOption = 'alphabetical'.obs;

  Map<String, String> sortOptions = {
    'default': 'Domyślnie',
    'alphabetical': 'Alfabetycznie'
  };

  Future<void> getAllFriends(bool isMyProfile, String? username) async {
    try {
      dynamic response;
      if (isMyProfile) {
        response = await _restService.sendGETRequest(
          'http://10.0.2.2:8080/api/friends/all',
        );
      } else {
        response = await _restService.sendGETRequest(
          "http://10.0.2.2:8080/api/friends/all/$username",
        );
      }
      friendsList.value =
          List<String>.from(response.map((friend) => friend['username'] as String));
      _applyFilters();
    } catch (e) {
      Get.snackbar('Error', 'Error fetching friends: $e', backgroundColor: Colors.red);
    }
  }

  void updateSortOption(String newSortOption) {
    currentSortOption.value = newSortOption;
    _applyFilters();
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
    _applyFilters();
  }

  void _applyFilters() {
    var list = List<String>.from(friendsList);
    if (searchQuery.isNotEmpty) {
      list = list.where((friend) => friend.toLowerCase().startsWith(searchQuery.value.toLowerCase())).toList();
    }
    if (currentSortOption.value == 'default') {
      list.sort((a, b) => b.toLowerCase().compareTo(a.toLowerCase()));
    } else {
      list.sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
    }
    filteredFriendsList.value = list;
  }

  Future<void> addFriend(String username) async {
    try {
      await _restService.sendPOSTRequest(
        'http://10.0.2.2:8080/api/friends/add',
        {'username': username},
      );
      Get.snackbar('Sukcess', 'Pomyślnie dodano znajomego', backgroundColor: Get.theme.primaryColor);
    } catch (ex) {
      Get.snackbar('Błąd', "Błąd dodawania znajomego: $ex", backgroundColor: Colors.red);
    }
  }

  Future<void> deleteFriend(String username) async {
    try {
      await _restService.sendPOSTRequest(
        'http://10.0.2.2:8080/api/friends/delete',
        {'username': username},
      );
      Get.snackbar('Sukcess', 'Pomyślnie usunięto znajomego', backgroundColor: Get.theme.primaryColor);
    } catch (ex) {
      Get.snackbar('Błąd', "Błąd usuwania znajomego: $ex", backgroundColor: Colors.red);
    }
  }
}
