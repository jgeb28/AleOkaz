import 'package:ale_okaz/models/data/friend.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:ale_okaz/models/services/rest_service.dart';

class FriendsTabViewModel extends GetxController {
  final RestService _restService = RestService();

  var friendsList = <Friend>[].obs;
  var filteredFriendsList = <Friend>[].obs;
  var searchQuery = ''.obs;
  var currentSortOption = 'alphabetical'.obs;

  Map<String, String> sortOptions = {
    'default': 'Domyślnie',
    'alphabetical': 'Alfabetycznie'
  };

  Future<void> getAllFriends(bool isMyProfile, String? username) async {
    try {
      dynamic response =
          await _restService.sendGETRequest("/friends/allof/$username");

      friendsList.value = List<Friend>.from(response.map(
          (friend) => Friend(id: friend['id'], username: friend['username'])));
      _applyFilters();
      
    } catch (e) {
      Get.snackbar('Błąd', 'Błąd podczas wczytywania danych: $e',
          backgroundColor: Colors.red);
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
    var list = List<Friend>.from(friendsList);

    if (searchQuery.value.isNotEmpty) {
      list = list
          .where((friend) => friend.username
              .toLowerCase()
              .startsWith(searchQuery.value.toLowerCase()))
          .toList();
    }

    if (currentSortOption.value == 'default') {
      list.sort((a, b) =>
          b.username.toLowerCase().compareTo(a.username.toLowerCase()));
    } else {
      list.sort((a, b) =>
          a.username.toLowerCase().compareTo(b.username.toLowerCase()));
    }

    filteredFriendsList.value = list;
  }

  Future<void> addFriend(String username) async {
    try {
      await _restService.sendPOSTRequest(
        '/friends/add',
        {'username': username},
      );
      Get.snackbar('Sukcess', 'Pomyślnie dodano znajomego',
          backgroundColor: Colors.green);
    } catch (ex) {
      Get.snackbar('Błąd', "Błąd dodawania znajomego: $ex",
          backgroundColor: Colors.red);
    }
  }

  Future<void> deleteFriend(String username) async {
    try {
      await _restService.sendPOSTRequest(
        '/friends/remove',
        {'username': username},
      );
      Get.snackbar('Sukcess', 'Pomyślnie usunięto znajomego',
          backgroundColor: Colors.green);
      await getAllFriends(true, null);
    } catch (ex) {
      Get.snackbar('Błąd', "Błąd usuwania znajomego: $ex",
          backgroundColor: Colors.red);
    }
  }
}
