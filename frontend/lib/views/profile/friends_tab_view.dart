import 'package:ale_okaz/view_models/profile/friends_tab_view_model.dart';
import 'package:ale_okaz/view_models/profile/profile_view_model.dart';
import 'package:ale_okaz/views/profile/profile_view.dart';
import 'package:flutter/material.dart';
import 'package:ale_okaz/widgets/friend_container.dart';
import 'package:ale_okaz/widgets/my_dropdown_menu.dart';
import 'package:ale_okaz/widgets/my_search_bar.dart';
import 'package:get/get.dart';

class FriendsTab extends StatelessWidget {
  final String? username;
  final bool isMyProfile;

  FriendsTab({required this.isMyProfile, required this.username, super.key});

  final FriendsTabViewModel viewModel = Get.put(FriendsTabViewModel());

  @override
  Widget build(BuildContext context) {
    viewModel.getAllFriends(isMyProfile, username);

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
              return const Center(child: Text("No friends found."));
            }

            Map<String, String> friendOptions = isMyProfile
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
