import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraProvider extends ChangeNotifier {
  CameraController? controller;

  bool _isCameraBackSelected = true;
  bool get isCameraBackSelected => _isCameraBackSelected;

  bool _isCameraInitialize = false;
  bool get isCameraInitialize => _isCameraInitialize;

  void switchCamera() {
    _isCameraInitialize = false;
    _isCameraBackSelected = !_isCameraBackSelected;
    notifyListeners();
  }

  Future<void> onNewCameraSelected(CameraDescription cameraDescription) async {
    final previousController = controller;

    final cameraController =
        CameraController(cameraDescription, ResolutionPreset.medium);

    await previousController?.dispose();

    try {
      await cameraController.initialize();
    } on CameraException catch (e) {
      throw 'Error initializin camera: $e';
    }

    controller = cameraController;
    notifyListeners();
  }

  void closeCamera() {
    controller?.dispose();
  }
}
