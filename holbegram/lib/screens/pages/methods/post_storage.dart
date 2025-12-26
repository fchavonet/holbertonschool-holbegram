import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class PostStorage {
  // Firebase services.
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  /// Uploads a post image and creates the Firestore post document.
  Future<String> uploadPost(
    String caption,
    String uid,
    String username,
    String profImage,
    Uint8List file,
  ) async {
    String result = 'Some error occurred';

    try {
      final String postId = const Uuid().v1();

      // Upload image to Firebase Storage.
      final Reference ref = _storage.ref().child('posts').child('$postId.jpg');

      final UploadTask uploadTask = ref.putData(file);
      final TaskSnapshot snapshot = await uploadTask;

      final String postUrl = await snapshot.ref.getDownloadURL();

      // Create post document in Firestore.
      await _firestore.collection('posts').doc(postId).set({
        'caption': caption,
        'uid': uid,
        'username': username,
        'profImage': profImage,
        'postUrl': postUrl,
        'datePublished': FieldValue.serverTimestamp(),
        'likes': [],
      });

      result = 'Ok';
    } catch (e) {
      result = e.toString();
    }

    return result;
  }
}
