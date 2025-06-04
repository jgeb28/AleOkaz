import 'package:ale_okaz/consts/colors.dart';
import 'package:ale_okaz/consts/flutter_api_consts.dart';
import 'package:ale_okaz/services/rest_service.dart';
import 'package:ale_okaz/models/data/friend.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class FriendsTabViewModel extends GetxController {
  final RestService _restService = RestService();

  var username = ''.obs;
  var friendsList = <Friend>[].obs;
  var filteredFriendsList = <Friend>[].obs;
  var searchQuery = ''.obs;
  var currentSortOption = 'alphabetical'.obs;
  var incomingRequests = <Friend>[].obs;

  Map<String, String> sortOptions = {
    'default': 'Domyślnie',
    'alphabetical': 'Alfabetycznie'
  };

  Future<void> getAllFriends(bool isMyProfile, String? username) async {
    try {
      final url = 'api/friends/allof/$username';

      final friends = await _restService.sendGETRequest<List<Friend>>(
        url,
        (decodedJson) {
          return (decodedJson as List)
              .map((friend) => Friend(
                  id: friend['id'],
                  username: friend['username'],
                  imageUrl: friend['avatar_url']))
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

  Future<void> getIncomingFriendRequests() async {
    try {
      final requests = await _restService.sendGETRequest<List<Friend>>(
        'api/friends/incoming',
        (decodedJson) {
          return (decodedJson as List)
              .map((friend) => Friend(
                  id: friend['id'],
                  username: friend['username'],
                  imageUrl: friend['avatar_url']))
              .toList();
        },
      );

      incomingRequests.value = requests;
    } catch (e) {
      Get.snackbar(
        'Błąd',
        'Błąd podczas wczytywania zaproszeń: $e',
        backgroundColor: Colors.red,
      );
    }
  }

  void showIncomingRequestsDialog(BuildContext context) async {
    await getIncomingFriendRequests();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Zaproszenia",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 6),
              Container(
                height: 2,
                width: double.infinity,
                color: smallTextColor, // Change to any color you like
              ),
            ],
          ),
          content: Obx(() {
            if (incomingRequests.isEmpty) {
              return Text(
                "Brak zaproszeń.",
                textAlign: TextAlign.center,
              );
            }

            return SizedBox(
              width: double.maxFinite,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: incomingRequests.length,
                itemBuilder: (context, index) {
                  final friend = incomingRequests[index];
                  return ListTile(
                    leading: Container(
                        width: 40.0,
                        height: 40.0,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                fit: BoxFit.fill,
                                image: NetworkImage(
                                    "${FlutterApiConsts.baseUrl}/${friend.imageUrl.substring(22)}")))),
                    title: Text(friend.username),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.check, color: Colors.green),
                          onPressed: () {
                            addFriend(friend.username);
                            incomingRequests.removeWhere(
                                (f) => f.username == friend.username);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.close, color: Colors.red),
                          onPressed: () {
                            removeFriendRequest(friend.username);
                            incomingRequests.removeWhere(
                                (f) => f.username == friend.username);
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          }),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Zamknij",
                  style: TextStyle(color: smallTextColor)),
            ),
          ],
        );
      },
    );
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

  Future<void> addFriend(String userToAdd) async {
    try {
      await _restService.sendPOSTRequest<void>(
        'api/friends/add',
        payload: {'username': userToAdd},
        parser: (decodedJson) => {},
      );
      await getAllFriends(true, username.value);
      Get.snackbar(
        'Sukces',
        'Pomyślnie dodano znajomego',
        backgroundColor: Colors.green,
      );
    } catch (ex) {
      Get.snackbar('Błąd', "Błąd dodawania znajomego: $ex",
          backgroundColor: Colors.red);
    }
  }

  Future<void> deleteFriend(String username) async {
    try {
      await _restService.sendPOSTRequest('api/friends/remove',
          payload: {'username': username}, parser: (decodedJson) => {});

      Get.snackbar('Sukcess', 'Pomyślnie usunięto znajomego',
          backgroundColor: Colors.green);
      await getAllFriends(true, null);
    } catch (ex) {
      Get.snackbar('Błąd', "Błąd usuwania znajomego: $ex",
          backgroundColor: Colors.red);
    }
  }

  Future<void> removeFriendRequest(String username) async {
    try {
      await _restService.sendPOSTRequest('api/friends/deleterequest',
          payload: {'username': username}, parser: (decodedJson) => {});

      Get.snackbar('Sukcess', 'Pomyślnie odrzucono zaproszenie',
          backgroundColor: Colors.green);
      await getAllFriends(true, null);
    } catch (ex) {
      Get.snackbar('Błąd', "Błąd odrzucenia zaproszenia znajomego: $ex",
          backgroundColor: Colors.red);
    }
  }
}
