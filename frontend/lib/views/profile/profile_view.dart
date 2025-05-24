import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ale_okaz/consts/colors.dart';
import 'package:ale_okaz/views/profile/fishing_spots_tab_view.dart';
import 'package:ale_okaz/views/profile/friends_tab_view.dart';
import 'package:ale_okaz/views/profile/posts_tab_view.dart';
import 'package:ale_okaz/views/profile/profile_tab_view.dart';
import 'package:ale_okaz/widgets/profile_tabs.dart';
import 'package:ale_okaz/view_models/profile/profile_view_model.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late ProfileViewModel viewModel;

  @override
  void initState() {
    Get.delete<ProfileViewModel>();
    viewModel = Get.put(ProfileViewModel());
    super.initState();
  }

  @override
  void dispose() {
    Get.delete<ProfileViewModel>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final TabController tabController = TabController(length: 4, vsync: Navigator.of(context));
    

    return Obx(() => Scaffold(
          appBar: AppBar(
            title: Text(
              viewModel.username.value,
              style: const TextStyle(
                fontFamily: 'Righteous',
                fontSize: 16,
              ),
            ),
            centerTitle: true,
            backgroundColor: primaryBackgroundColor,
            actions: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20.0),
                child: viewModel.isMyProfile.value
                    ? 
                    PopupMenuButton<String>(
                      onSelected: (String choice) {  
                        if(choice == "logout") {
                          viewModel.logout();
                        }
                      },
                      icon: const Icon(Icons.more_horiz, color: tabGreenColor,),
                      itemBuilder: 
                        (BuildContext context) => <PopupMenuEntry<String>> [
                          const PopupMenuItem(value: "logout", child:  Text('Wyloguj')),

                        ],
                    )
                    : IconButton(
                        onPressed: viewModel.addFriend,
                        icon: const Icon(Icons.person_add_rounded),
                      ),
              )
            ],
            bottom: ProfileTabs(tabController: tabController),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: TabBarView(
              controller: tabController,
              children: <Widget>[
                ProfileTab(username: viewModel.username.value, isMyProfile: viewModel.isMyProfile.value, profilePictureUrl: viewModel.profilePictureUrl.value),
                PostsTab(isMyProfile: viewModel.isMyProfile.value, userId: viewModel.userId.value),
                const FishingSpotsTab(),
                FriendsTab(
                  isMyProfile: viewModel.isMyProfile.value,
                  username: viewModel.username.value,
                ),
              ],
            ),
          ),
        ));
  }
}
