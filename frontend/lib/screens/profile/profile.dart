import 'package:ale_okaz/widgets/profile_tabs.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:ale_okaz/services/auth_service.dart';

import 'package:ale_okaz/utils/colors.dart';
import 'package:ale_okaz/screens/profile/fishing_spots_tab.dart';
import 'package:ale_okaz/screens/profile/friends_tab.dart';
import 'package:ale_okaz/screens/profile/posts_tab.dart';
import 'package:ale_okaz/screens/profile/profile_tab.dart';
import 'package:ale_okaz/widgets/bottom_navbar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with TickerProviderStateMixin {
  late final TabController _tabController;
  final AuthService _authService = AuthService();
  String? _username;
  bool _isMyProfile = false;

  Future<void> _loadUsername() async {
    _username = Get.parameters['username'];
    if (_username == null) {
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        String? name = prefs.getString('username');
        if (name == null) {
          Get.offAllNamed('/login');
        }
        _isMyProfile = true;
        _username = name;
      });
    }
  }

  Future<void> _addFriend() async {
    try {
      await _authService.sendPOSTRequest(
        'http://10.0.2.2:8080/api/friends/add',
        {'username': _username},
      );
      Get.snackbar('Sukcess', 'Pomyślnie dodano znajomego',
      backgroundColor: Colors.green,
      );
    } catch (ex) {
      Get.snackbar('Błąd', "Coś poszło nie tak w trakcie dodawania znajomego : $ex",
      backgroundColor: Colors.red,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _loadUsername();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return (Scaffold(
      appBar: AppBar(
        title: Text(
          _username ?? "Loading...",
          style: const TextStyle(
            fontFamily: 'Righteous',
            fontSize: 16,
          ),
        ),
        centerTitle: true,
        backgroundColor: primaryBackgroundColor,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 20.0, left: 20.0),
            child: _isMyProfile
                ? const Icon(Icons.settings)
                : IconButton(
                    onPressed: _addFriend,
                    icon: const Icon(Icons.person_add_rounded)),
          )
        ],
        bottom: ProfileTabs(tabController: _tabController),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TabBarView(
          controller: _tabController,
          children: <Widget>[
            ProfileTab(username: _username, isMyProfile: _isMyProfile),
            PostsTab(isMyProfile: _isMyProfile),
            FishingSpotsTab(),
            FriendsTab(
              isMyProfile: _isMyProfile,
              username: _username,
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavbar(),
    ));
  }
}
