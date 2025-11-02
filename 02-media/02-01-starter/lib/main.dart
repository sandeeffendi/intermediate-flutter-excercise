import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:take_image/provider/camera_provider.dart';

import 'provider/home_provider.dart';
import 'screen/home_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HomeProvider()),
        ChangeNotifierProvider(create: (_) => CameraProvider())
      ],
      child: const MaterialApp(
        home: HomePage(),
      ),
    ),
  );
}
