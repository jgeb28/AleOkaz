import 'package:flutter/material.dart';

import 'package:ale_okaz/services/auth_service.dart';

import 'package:ale_okaz/widgets/friend_container.dart';
import 'package:ale_okaz/widgets/my_dropdown_menu.dart';
import 'package:ale_okaz/widgets/my_search_bar.dart';

class FriendsTab extends StatefulWidget {
  const FriendsTab({super.key});

  @override
  State<FriendsTab> createState() => _FriendsTabState();
}

class _FriendsTabState extends State<FriendsTab> {
  String currentSortOption = "alphabetical";
  String selectedItem = "item";
  TextEditingController searchController = TextEditingController();
  final _authService = AuthService();

  List<String> filteredFriendsList = [];

  Map<String, String> sortOptions = {
    'default': 'Domyślnie',
    'alphabetical': 'Alfabetycznie'
  };

  void updateSortOption(String newSortOption) {
    setState(() {
      currentSortOption = newSortOption;
    });
  }

  List<String> _filterAndSortFriends(List<String> friendsNames) {
    String query = searchController.text;

    if (query.isEmpty) {
        filteredFriendsList = friendsNames;
      } else {
        filteredFriendsList = friendsNames
            .where((friend) =>
                friend.toLowerCase().startsWith(query.toLowerCase()))
            .toList();
      };

      if (currentSortOption == 'default') {
      filteredFriendsList.sort((a, b) => b.toLowerCase().compareTo(a.toLowerCase()));
      } else if (currentSortOption == 'alphabetical') {
        filteredFriendsList.sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
      }

    return filteredFriendsList;
  }

  Future<List<String>> getAllFriends() async {
    try {
      dynamic response = await _authService.sendGETRequest(
        'http://10.0.2.2:8080/api/friends/all',
      );

      List<String> friendNames = List<String>.from(
          response.map((friend) => friend['username'] as String));
      return friendNames;
    } catch (e) {
      throw 'Error fetching friends: $e';
    }
  }

  @override
  void initState() {
    super.initState();
    searchController.addListener(
      () {
      setState(() {});
      }
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return (Column(
      children: [
        MySearchBar(controller: searchController),
        const SizedBox(height: 6),
        Row(
          children: [
            MyDropdownMenu(
              sortOptions: sortOptions,
              currentSortOption: currentSortOption,
              onSortOptionChanged: updateSortOption,
            ),
          ],
        ),
        const SizedBox(height: 6),
        Expanded(
          child: FutureBuilder(
              future: getAllFriends(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("No friends found."));
                }

                List<String> friendsList = snapshot.data!;
                List<String> filteredFriendsList = _filterAndSortFriends(friendsList);

                return ListView(
                  children: filteredFriendsList.map((String name) {
                    return FriendContainer(
                      friendName: name,
                      onSelected: (String choice) async {
                        if (choice == 'delete') {
                          try {
                            await _authService.sendPOSTRequest(
                              'http://10.0.2.2:8080/api/friends/remove',
                              {'username': name},
                            );
                            setState(() {});
                          } catch (ex) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                backgroundColor: Colors.red,
                                content: Center(child: Text('$ex'))));
                          }
                        }
                      },
                    );
                  }).toList(),
                );
              }),
        ),
      ],
    ));
  }
}
