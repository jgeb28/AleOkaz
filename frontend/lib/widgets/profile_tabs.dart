import 'package:flutter/material.dart';
import 'package:ale_okaz/consts/colors.dart';

class ProfileTabs extends StatelessWidget implements PreferredSizeWidget {
  final TabController tabController;

  const ProfileTabs({required this.tabController, super.key});

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(24),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Container(
          decoration: const BoxDecoration(
              border:
                  Border(bottom: BorderSide(width: 1.0, color: tabGreenColor))),
          child: TabBar(
            controller: tabController,
            indicator: const UnderlineTabIndicator(
                borderSide: BorderSide(width: 3.0, color: tabGreenColor)),
            indicatorSize: TabBarIndicatorSize.tab,
            labelStyle:
                const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            unselectedLabelStyle:
                const TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
            labelColor: Colors.black,
            unselectedLabelColor: Colors.black,
            indicatorColor: tabGreenColor,
            tabs: const <Widget>[
              Tab(text: 'Profil'),
              Tab(text: 'Posty'),
              Tab(text: 'Łowiska'),
              Tab(text: 'Znajomi')
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(24);
}
