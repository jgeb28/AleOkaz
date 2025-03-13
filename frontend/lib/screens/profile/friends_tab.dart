import 'package:ale_okaz/utils/colors.dart';
import 'package:ale_okaz/widgets/friend_container.dart';
import 'package:ale_okaz/widgets/my_dropdown_menu.dart';
import 'package:flutter/material.dart';
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
  
  List<String> friendsNames = ['Joanna', 'Zbigniew', 'Grzegorz', 'Marcin', 'Maniek', 'Joanna', 'Zbigniew', 'Grzegorz', 'Marcin', 'Maniek', 'Joanna', 'Zbigniew', 'Grzegorz', 'Marcin', 'Maniek'];
  List<String> filteredFriendsNames = [];
  Map<String,String> sortOptions = {'default':'Domyślnie','alphabetical':'Alfabetycznie'};

  void updateSortOption(String newSortOption) {
    setState(() {
      currentSortOption = newSortOption; // Update sort option
    });
  }

  void _filterFriends() {
    String query = searchController.text;

    if (query.isEmpty) {
      setState(() {
        filteredFriendsNames = friendsNames;
      });
    } else {
      setState(() {
        filteredFriendsNames = friendsNames
            .where((friend) => friend.toLowerCase().startsWith(query.toLowerCase()))
            .toList();
      });
    }
  }
 @override
  void initState() {
    super.initState();
    
    filteredFriendsNames = friendsNames;

    searchController.addListener(_filterFriends);
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
          child: ListView(
          children: () {
            if(currentSortOption == 'alphabetical') {
              filteredFriendsNames.sort();
            }else if(currentSortOption == 'default') {
              filteredFriendsNames.sort((a,b)=>b.compareTo(a));
            }
            return filteredFriendsNames.map((String name)=>FriendContainer(friendName: name)).toList();
          }()),
        )
      ],
    ));
  }
}
