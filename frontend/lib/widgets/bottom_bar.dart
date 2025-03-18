import 'package:ale_okaz/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BottomBar extends StatelessWidget {
  const BottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(40),
        topRight: Radius.circular(40),
      ),
      child: BottomAppBar(
          height: 60,
          color: componentColor,
          child: SizedBox(
              child: Row(children: [
            Expanded(
              child: InkWell(
                onTap: () => {},
                child: const SizedBox.expand(child: Icon(Icons.location_on)),
              ),
            ),
            Expanded(
              child: InkWell(
                onTap: () => {Get.toNamed('/take-picture')},
                child: const SizedBox.expand(child: Icon(Icons.photo_camera)),
              ),
            ),
            Expanded(
              child: InkWell(
                onTap: () => {},
                child: const SizedBox.expand(child: Icon(Icons.account_circle)),
              ),
            )
          ]))),
    );
  }
}
