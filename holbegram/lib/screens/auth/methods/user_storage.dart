import 'dart:convert';
import 'dart:typed_data';

// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

class StorageMethods {
  // Cloudinary configuration
  final String cloudinaryUrl =
      'https://api.cloudinary.com/v1_1/your-cloud-name/image/upload';
  final String cloudinaryPreset = 'your-upload-preset';

  /// Uploads an image to Cloudinary and returns the secure URL.
  Future<String> uploadImageToStorage(
    bool isPost,
    String childName,
    Uint8List file,
  ) async {
    final String uniqueId = const Uuid().v1();

    final Map<String, dynamic> response = await _uploadImage(
      file: file,
      folder: childName,
      publicId: isPost ? uniqueId : null,
      filename: '$uniqueId.jpg',
    );

    return response['secure_url'] ?? '';
  }

  /// Uploads a post image and returns its metadata.
  Future<Map<String, String>> uploadPostImage({
    required String childName,
    required Uint8List file,
  }) async {
    final String uniqueId = const Uuid().v1();

    final Map<String, dynamic> response = await _uploadImage(
      file: file,
      folder: childName,
      publicId: uniqueId,
      filename: '$uniqueId.jpg',
    );

    return {
      'url': response['secure_url'] ?? '',
      'postId': uniqueId,
      'publicId': uniqueId,
    };
  }

  /// Low-level Cloudinary upload handler.
  Future<Map<String, dynamic>> _uploadImage({
    required Uint8List file,
    required String folder,
    required String filename,
    String? publicId,
  }) async {
    final Uri uri = Uri.parse(cloudinaryUrl);
    final http.MultipartRequest request = http.MultipartRequest('POST', uri);

    request.fields['upload_preset'] = cloudinaryPreset;
    request.fields['folder'] = folder;

    if (publicId != null && publicId.isNotEmpty) {
      request.fields['public_id'] = publicId;
    }

    request.files.add(
      http.MultipartFile.fromBytes('file', file, filename: filename),
    );

    final http.StreamedResponse response = await request.send();

    if (response.statusCode != 200) {
      throw Exception('Failed to upload image to Cloudinary');
    }

    final List<int> bytes = await response.stream.toBytes();
    return jsonDecode(String.fromCharCodes(bytes));
  }

  /// Deletes a post image from Cloudinary.
  /// Not implemented yet...
  Future<void> deletePostImage({required String publicId}) async {
    return;
  }
}
