import 'package:ale_okaz/utils/colors.dart';
import 'package:ale_okaz/widgets/top_bar/title_text.dart';
import 'package:flutter/material.dart';

class TopBar extends StatelessWidget implements PreferredSizeWidget {
  final bool hasBackButton;
  const TopBar({
    super.key,
    this.hasBackButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: componentColor,
      centerTitle: true,
      titleSpacing: 0,
      title: const TitleText(),
      automaticallyImplyLeading: hasBackButton,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(40),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
