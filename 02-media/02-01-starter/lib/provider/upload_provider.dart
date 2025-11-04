import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:take_image/data/datasource/upload_image_datasource.dart';
import 'package:take_image/data/model/upload_response_model.dart';
import 'package:image/image.dart' as img;

class UploadProvider extends ChangeNotifier {
  final UploadImageDatasource uploadImageDatasource;

  UploadProvider(this.uploadImageDatasource);

  String message = '';
  bool isUploading = false;
  UploadResponse? uploadResponse;

  Future<void> upload(
      List<int> bytes, String fileName, String description) async {
    try {
      isUploading = true;
      uploadResponse = null;
      message = '';
      notifyListeners();

      uploadResponse = await uploadImageDatasource.uploadDocument(
          bytes, fileName, description);
      message = uploadResponse?.message.toString() ?? 'success';
      isUploading = false;

      notifyListeners();
    } catch (e) {
      isUploading = false;
      message = e.toString();
      notifyListeners();
    }
  }

  Future<List<int>> compressImage(List<int> bytes) async {
    int imageLength = bytes.length;
    if (imageLength < 1000000) return bytes;

    final img.Image image = img.decodeImage(Uint8List.fromList(bytes))!;
    int compressQuality = 100;
    int length = imageLength;
    List<int> newByte = [];

    do {
      compressQuality -= 10;

      newByte = img.encodeJpg(image, quality: compressQuality);
      length = newByte.length;
    } while (length > 1000000);

    return newByte;
  }
}
