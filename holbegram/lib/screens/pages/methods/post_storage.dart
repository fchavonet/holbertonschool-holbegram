import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class PostStorage {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadPost(
    String caption,
    String uid,
    String username,
    String profImage,
    Uint8List file,
  ) async {
    String res = "Some error occurred";

    try {
      final String postId = const Uuid().v1();

      final Reference ref = _storage.ref().child("posts").child("$postId.jpg");

      final UploadTask uploadTask = ref.putData(file);
      final TaskSnapshot snap = await uploadTask;

      final String postUrl = await snap.ref.getDownloadURL();

      await _firestore.collection("posts").doc(postId).set({
        "caption": caption,
        "uid": uid,
        "username": username,
        "profImage": profImage,
        "postUrl": postUrl,
        "datePublished": FieldValue.serverTimestamp(),
        "likes": [],
      });

      res = "Ok";
    } catch (err) {
      res = err.toString();
    }

    return res;
  }
}
