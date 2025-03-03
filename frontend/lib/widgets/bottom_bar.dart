import 'package:ale_okaz/screens/posts/take_picture.dart';
import 'package:ale_okaz/utils/camera_provider.dart';
import 'package:ale_okaz/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
                onTap: () => {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => TakePictureScreen(
                          camera: Provider.of<CameraProvider>(context)
                              .cameras
                              .first)))
                },
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
