import 'package:ale_okaz/utils/colors.dart';
import 'package:ale_okaz/widgets/title_section.dart';
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
      title: const TitleSection(
        name: "AleOkaz",
        fontSize: 24,
      ),
      automaticallyImplyLeading: hasBackButton,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(40),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
