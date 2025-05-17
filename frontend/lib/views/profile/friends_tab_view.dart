import 'package:ale_okaz/view_models/profile/friends_tab_view_model.dart';
import 'package:flutter/material.dart';
import 'package:ale_okaz/widgets/friend_container.dart';
import 'package:ale_okaz/widgets/my_dropdown_menu.dart';
import 'package:ale_okaz/widgets/my_search_bar.dart';
import 'package:get/get.dart';

class FriendsTab extends StatefulWidget {
  final String? username;
  final bool isMyProfile;

  const FriendsTab({required this.isMyProfile, required this.username, super.key});

  @override
  State<FriendsTab> createState() => _FriendsTabState();
}

class _FriendsTabState extends State<FriendsTab> {
  late FriendsTabViewModel viewModel;

  @override
  void initState() {
    Get.delete<FriendsTabViewModel>();
    viewModel = Get.put(FriendsTabViewModel());
    super.initState();
  }

  @override
  void dispose() {
    Get.delete<FriendsTabViewModel>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    viewModel.getAllFriends(widget.isMyProfile, widget.username);

    return Column(
      children: [
        MySearchBar(
          controller: TextEditingController(),
          onChanged: viewModel.updateSearchQuery,
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Obx(() => MyDropdownMenu(
                  sortOptions: viewModel.sortOptions,
                  currentSortOption: viewModel.currentSortOption.value,
                  onSortOptionChanged: viewModel.updateSortOption,
                )),
          ],
        ),
        const SizedBox(height: 6),
        Expanded(
          child: Obx(() {
            if (viewModel.filteredFriendsList.isEmpty) {
              return const Center(child: Text("Nie znaleziono przyjaciół :("));
            }

            Map<String, String> friendOptions = widget.isMyProfile
                ? {'profile': 'Profil', 'delete': 'Usuń'}
                : {'profile': 'Profil', 'add': 'Dodaj'};

            return ListView(
              children: viewModel.filteredFriendsList.map((String name) {
                return FriendContainer(
                  friendName: name,
                  friendOptions: friendOptions,
                  onSelected: (String choice) {
                    if (choice == 'delete') {
                      viewModel.deleteFriend(name);
                    } else if (choice == 'profile') {
                      Get.toNamed("/profile/$name");
                    } else if (choice == 'add') {
                      viewModel.addFriend(name);
                    }
                  },
                );
              }).toList(),
            );
          }),
        ),
      ],
    );
  }
}
