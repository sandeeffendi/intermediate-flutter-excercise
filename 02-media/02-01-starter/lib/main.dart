import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:take_image/data/datasource/upload_image_datasource.dart';
import 'package:take_image/provider/camera_provider.dart';
import 'package:take_image/provider/upload_provider.dart';

import 'provider/home_provider.dart';
import 'screen/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final UploadImageDatasource uploadImageDatasource = UploadImageDatasource();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => UploadProvider(uploadImageDatasource)),
        ChangeNotifierProvider(create: (_) => HomeProvider()),
        ChangeNotifierProvider(create: (_) => CameraProvider())
      ],
      child: const MaterialApp(
        home: HomePage(),
      ),
    ),
  );
}
