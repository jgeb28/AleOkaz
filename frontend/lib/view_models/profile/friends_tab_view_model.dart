import 'package:ale_okaz/services/rest_service.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

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
      final url = isMyProfile ? '/friends/all' : '/friends/allof/$username';

      final friends = await _restService.sendGETRequest<List<String>>(
        url,
        (decodedJson) {
          return (decodedJson as List)
              .map((friend) => friend['username'] as String)
              .toList();
        },
      );

      friendsList.value = friends;
      _applyFilters();
    } catch (e) {
      Get.snackbar(
        'Błąd',
        'Błąd podczas wczytywania danych: $e',
        backgroundColor: Colors.red,
      );
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
      list = list
          .where((friend) =>
              friend.toLowerCase().startsWith(searchQuery.value.toLowerCase()))
          .toList();
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
      await _restService.sendPOSTRequest<void>(
        '/friends/add',
        payload: {'username': username},
        parser: (decodedJson) => {},
      );
      Get.snackbar(
        'Sukces',
        'Pomyślnie dodano znajomego',
        backgroundColor: Colors.green,
      );
    } catch (ex) {
      Get.snackbar(
        'Błąd',
        'Błąd dodawania znajomego: $ex',
        backgroundColor: Colors.red,
      );
    }
  }

  Future<void> deleteFriend(String username) async {
    try {
      await _restService.sendPOSTRequest('/friends/remove',
          payload: {'username': username}, parser: (decodedJson) => {});

      Get.snackbar('Sukcess', 'Pomyślnie usunięto znajomego',
          backgroundColor: Colors.green);
      await getAllFriends(true, null);
    } catch (ex) {
      Get.snackbar('Błąd', "Błąd usuwania znajomego: $ex",
          backgroundColor: Colors.red);
    }
  }
}
