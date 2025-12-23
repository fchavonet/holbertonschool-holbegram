import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

class StorageMethods {
  final String cloudinaryUrl =
      "https://api.cloudinary.com/v1_1/your-cloud-name/image/upload";
  final String cloudinaryPreset = "your-upload-preset";

  /// Existing method (kept)
  Future<String> uploadImageToStorage(
    bool isPost,
    String childName,
    Uint8List file,
  ) async {
    String uniqueId = const Uuid().v1();
    var uri = Uri.parse(cloudinaryUrl);
    var request = http.MultipartRequest('POST', uri);
    request.fields['upload_preset'] = cloudinaryPreset;
    request.fields['folder'] = childName;
    request.fields['public_id'] = isPost ? uniqueId : '';

    var multipartFile = http.MultipartFile.fromBytes(
      'file',
      file,
      filename: '$uniqueId.jpg',
    );
    request.files.add(multipartFile);

    var response = await request.send();
    if (response.statusCode == 200) {
      var responseData = await response.stream.toBytes();
      var jsonResponse = jsonDecode(String.fromCharCodes(responseData));
      return jsonResponse['secure_url'];
    } else {
      throw Exception('Failed to upload image to Cloudinary');
    }
  }

  Future<Map<String, String>> uploadPostImage({
    required String childName,
    required Uint8List file,
  }) async {
    final String uniqueId = const Uuid().v1();

    var uri = Uri.parse(cloudinaryUrl);
    var request = http.MultipartRequest('POST', uri);
    request.fields['upload_preset'] = cloudinaryPreset;
    request.fields['folder'] = childName;

    request.fields['public_id'] = uniqueId;

    var multipartFile = http.MultipartFile.fromBytes(
      'file',
      file,
      filename: '$uniqueId.jpg',
    );
    request.files.add(multipartFile);

    var response = await request.send();
    if (response.statusCode != 200) {
      throw Exception('Failed to upload image to Cloudinary');
    }

    var responseData = await response.stream.toBytes();
    var jsonResponse = jsonDecode(String.fromCharCodes(responseData));

    final String url = (jsonResponse['secure_url'] ?? '') as String;

    return {"url": url, "postId": uniqueId, "publicId": uniqueId};
  }

  Future<void> deletePostImage({required String publicId}) async {
    return;
  }
}
