import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:take_image/provider/camera_provider.dart';

class CameraScreen extends StatefulWidget {
  final List<CameraDescription> camera;

  const CameraScreen({super.key, required this.camera});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen>
    with WidgetsBindingObserver {
  CameraController? controller;
  late CameraProvider _cameraProvider;

  @override
  void initState() {
    _cameraProvider = context.read<CameraProvider>();
    WidgetsBinding.instance.addObserver(this);

    Future.microtask(() async {
      await _cameraProvider.onNewCameraSelected(widget.camera.first);
      controller = _cameraProvider.controller;
    });

    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _cameraProvider.closeCamera();
    controller?.dispose();
    super.dispose();
  }

  // camera button click method
  void _onCameraButtonClick() async {
    final navigator = Navigator.of(context);

    final image = await controller?.takePicture();

    navigator.pop(image);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final cameraProvider = context.read<CameraProvider>();

    final CameraController? cameraController = cameraProvider.controller;

    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      cameraProvider.onNewCameraSelected(cameraController.description);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
        data: ThemeData.dark(),
        child: Scaffold(
          appBar: AppBar(
            actions: [
              Consumer<CameraProvider>(
                  builder: (context, cameraProvider, child) {
                return IconButton(
                    onPressed: () {
                      cameraProvider.onNewCameraSelected(
                          cameraProvider.isCameraBackSelected
                              ? widget.camera[0]
                              : widget.camera[1]);
                    },
                    icon: const Icon(Icons.camera));
              })
            ],
          ),
          body: Consumer<CameraProvider>(
              builder: (context, cameraProvider, child) {
            return Center(
                child: Stack(
              children: [
                cameraProvider.isCameraInitialize
                    ? CameraPreview(controller!)
                    : const Center(child: CircularProgressIndicator()),
                Align(
                  alignment: const Alignment(0, 0.09),
                  child: _actionWidget(),
                )
              ],
            ));
          }),
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
}
