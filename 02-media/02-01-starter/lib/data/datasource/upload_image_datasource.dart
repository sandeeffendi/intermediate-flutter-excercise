import 'dart:ffi';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:take_image/data/model/upload_response_model.dart';

class UploadImageDatasource {
  static const String baseUrl = 'https://story-api.dicoding.dev/v1';
  static const Map<String, String> uploadHeader = {
    "Content-type": "multipart/form-data"
  };

  Future<UploadResponse> uploadDocument(
    List<int> bytes,
    String fileName,
    String description,
  ) async {
    final uri = Uri.parse('$baseUrl/stories/guest');
    var request = http.MultipartRequest('POST', uri);

    final multiPartFile =
        http.MultipartFile.fromBytes('photo', bytes, filename: fileName);
    const Map<String, String> header = uploadHeader;
    final Map<String, String> field = {'description': description};

    request.fields.addAll(field);
    request.headers.addAll(header);
    request.files.add(multiPartFile);

    final http.StreamedResponse streamResponse = await request.send();
    final int statusCode = streamResponse.statusCode;

    final Uint8List responseList = await streamResponse.stream.toBytes();
    final String responseData = String.fromCharCodes(responseList);

    if (statusCode == 200 || statusCode == 201) {
      final uploadReponse = UploadResponse.fromJson(responseData);

      return uploadReponse;
    } else {
      throw Exception('Failed to upload document: $statusCode');
    }
  }
}
