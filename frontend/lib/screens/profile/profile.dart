import 'package:ale_okaz/screens/profile/fishing_spots_tab.dart';
import 'package:ale_okaz/screens/profile/friends_tab.dart';
import 'package:ale_okaz/screens/profile/posts_tab.dart';
import 'package:ale_okaz/screens/profile/profile_tab.dart';
import 'package:ale_okaz/widgets/bottom_navbar.dart';
import 'package:flutter/material.dart';
import 'package:ale_okaz/utils/colors.dart';
import 'package:get/get.dart';


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with TickerProviderStateMixin {

  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return(
        Scaffold(
          appBar:AppBar(
            title: const Text('Joanna',
            style: TextStyle(
                  fontFamily: 'Righteous',
                  fontSize: 16,
                ),),
            centerTitle: true,
            backgroundColor: primaryBackgroundColor,
            leading: Container(
                margin: const EdgeInsets.only(right: 20.0, left: 20.0),
                child: IconButton(icon: Icon(Icons.arrow_back), onPressed: () {
                  Get.back();
                },)),
                
            actions: [
              Container(
                margin: const EdgeInsets.only(right: 20.0, left: 20.0),
                child: const Icon(Icons.settings))
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(24),
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                child: Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        width: 1.0,
                        color: tabGreenColor))
                  ),
                  child: TabBar(
                    controller: _tabController,
                    indicator: const UnderlineTabIndicator(
                      borderSide: BorderSide(width: 3.0, color: tabGreenColor)
                    ),
                    indicatorSize: TabBarIndicatorSize.tab,
                    labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14), 
                    unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
                    labelColor: Colors.black,
                    unselectedLabelColor: Colors.black,
                    indicatorColor: tabGreenColor,
                    tabs: <Widget>[
                      Tab(text: 'Profil'),
                      Tab(text: 'Posty'),
                      Tab(text: 'Łowiska'),
                      Tab(text: 'Znajomi')
                    ],
                  ),
                ),
              ),
            ),
          ),
           body: Padding(
             padding: const EdgeInsets.all(16.0),
             child: TabBarView(
              controller: _tabController,
              children: const <Widget>[
                ProfileTab(),
                PostsTab(),
                FishingSpotsTab(),
                FriendsTab(),
              ],
                       ),
           ),
          bottomNavigationBar: const BottomNavbar(),
        ));
  }
}