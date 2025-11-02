import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraScreen extends StatefulWidget {
  final List<CameraDescription> camera;

  const CameraScreen({super.key, required this.camera});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? controller;
  bool _isCameraInitialize = false;

  @override
  Widget build(BuildContext context) {
    return Theme(
        data: ThemeData.dark(),
        child: Scaffold(
          appBar: AppBar(
            actions: [
              IconButton(
                  onPressed: () {
                    _onCameraSwitch();
                  },
                  icon: const Icon(Icons.camera))
            ],
          ),
          body: Center(
              child: Stack(
            children: [
              Align(
                alignment: const Alignment(0, 0.09),
                child: _actionWidget(),
              )
            ],
          )),
        ));
  }

  Widget _actionWidget() {
    return FloatingActionButton(
      tooltip: 'Ambil Gambar',
      heroTag: 'camera-tag',
      onPressed: () => _onCameraButtonClick(),
      child: const Icon(Icons.camera_alt),
    );
  }

  void onNewCameraSelected() async {}

  Future<void> _onCameraSwitch() async {}

  void _onCameraButtonClick() {}
}
