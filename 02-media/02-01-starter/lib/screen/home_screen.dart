import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:take_image/screen/camera_screen.dart';

import '../provider/home_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold( 
      appBar: AppBar(
        title: const Text("Camera Project"),
        actions: [
          IconButton(
            onPressed: () => _onUpload(),
            icon: const Icon(Icons.upload),
            tooltip: "Unggah",
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 3,
              child: context.watch<HomeProvider>().imagePath == null
                  ? const Align(
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.image,
                        size: 100,
                      ),
                    )
                  : _showImage(),
            ),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () => _onGalleryView(),
                    child: const Text("Gallery"),
                  ),
                  ElevatedButton(
                    onPressed: () => _onCameraView(),
                    child: const Text("Camera"),
                  ),
                  ElevatedButton(
                    onPressed: () => _onCustomCameraView(),
                    child: const Text("Custom Camera"),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  _onUpload() async {}

  _onGalleryView() async {
    final provider = context.read<HomeProvider>();

    final picker = ImagePicker();

    final isMacOS = defaultTargetPlatform == TargetPlatform.macOS;
    final isLinux = defaultTargetPlatform == TargetPlatform.linux;

    if (isMacOS || isLinux) return;

    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      provider.setImageFile(pickedFile);
      provider.setImagePath(pickedFile.path);
    }
  }

  _onCameraView() async {
    final provider = context.read<HomeProvider>();

    final isAndroid = defaultTargetPlatform == TargetPlatform.android;
    final isIOs = defaultTargetPlatform == TargetPlatform.iOS;
    final mobilePlatform = (isAndroid && isIOs);

    if (!mobilePlatform) return;

    final picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      provider.setImageFile(pickedFile);
      provider.setImagePath(pickedFile.path);
    }
  }

  _onCustomCameraView() async {
    final navigator = Navigator.of(context);
    final provider = context.read<HomeProvider>();

    final camera = await availableCameras();

    final XFile? resultImage = await navigator.push(MaterialPageRoute(
        builder: (context) => CameraScreen(
              camera: camera,
            )));

    if (resultImage != null) {
      provider.setImageFile(resultImage);
      provider.setImagePath(resultImage.path);
    }
  }

  Widget _showImage() {
    final imagePath = context.read<HomeProvider>().imagePath;

    return kIsWeb
        ? Image.network(
            imagePath.toString(),
            fit: BoxFit.cover,
          )
        : Image.file(
            File(imagePath.toString()),
            fit: BoxFit.contain,
          );
  }
}
