import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraProvider with ChangeNotifier {
  final List<CameraDescription> cameras;

  CameraProvider(this.cameras);
}
