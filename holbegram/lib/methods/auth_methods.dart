import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../models/user.dart';

class AuthMethode {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  /// Upload profile picture.
  Future<String> _uploadProfileImage({
    required String uid,
    required Uint8List file,
  }) async {
    final Reference ref = _storage.ref().child("profilePics").child("$uid.jpg");

    final UploadTask uploadTask = ref.putData(file);
    final TaskSnapshot snap = await uploadTask;

    final String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }

  /// Login.
  Future<String> login({
    required String email,
    required String password,
  }) async {
    String res = "Some error occurred :( !)";

    try {
      if (email.isEmpty || password.isEmpty) {
        return "Please fill all the fields...";
      }

      await _auth.signInWithEmailAndPassword(email: email, password: password);
      res = "success";
    } catch (err) {
      res = err.toString();
    }

    return res;
  }

  /// Signup.
  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    Uint8List? file,
  }) async {
    try {
      if (email.isEmpty || password.isEmpty || username.isEmpty) {
        return "Please fill all the fields...";
      }

      if (file == null) {
        return "Please select a profile picture";
      }

      final UserCredential cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final String uid = cred.user!.uid;

      // 1) Upload profile picture to Storage
      final String photoUrl = await _uploadProfileImage(uid: uid, file: file);

      // 2) Create Firestore user doc
      final Users user = Users(
        uid: uid,
        email: email,
        username: username,
        bio: '',
        photoUrl: photoUrl,
        followers: [],
        following: [],
        posts: [],
        saved: [],
        searchKey: username[0].toLowerCase(),
      );

      await _firestore.collection('users').doc(uid).set(user.toJson());

      return "success";
    } on FirebaseAuthException catch (e) {
      return e.message ?? e.toString();
    } catch (e) {
      return e.toString();
    }
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }

  /// Get user details
  Future<Users> getUserDetails() async {
    final User currentUser = _auth.currentUser!;

    final DocumentSnapshot snap = await _firestore
        .collection('users')
        .doc(currentUser.uid)
        .get();

    return Users.fromSnap(snap);
  }
}
