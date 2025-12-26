import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../models/user.dart';

class AuthMethode {
  // Firebase services.
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  /// Uploads the user's profile picture and returns its download URL.
  Future<String> _uploadProfileImage({
    required String uid,
    required Uint8List file,
  }) async {
    final Reference ref = _storage.ref().child('profilePics').child('$uid.jpg');

    final UploadTask uploadTask = ref.putData(file);
    final TaskSnapshot snapshot = await uploadTask;

    return snapshot.ref.getDownloadURL();
  }

  /// Signs in an existing user.
  Future<String> login({
    required String email,
    required String password,
  }) async {
    if (email.isEmpty || password.isEmpty) {
      return 'Please fill all the fields!';
    }

    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return 'success';
    } catch (e) {
      return e.toString();
    }
  }

  /// Creates a new user account.
  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    Uint8List? file,
  }) async {
    if (email.isEmpty || password.isEmpty || username.isEmpty) {
      return 'Please fill all the fields!';
    }

    if (file == null) {
      return 'Please select a profile picture!';
    }

    try {
      final UserCredential credential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      final String uid = credential.user!.uid;

      // Upload profile picture.
      final String photoUrl = await _uploadProfileImage(uid: uid, file: file);

      // Create user document.
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

      return 'success';
    } on FirebaseAuthException catch (e) {
      return e.message ?? e.toString();
    } catch (e) {
      return e.toString();
    }
  }

  /// Signs out the current user.
  Future<void> logout() async {
    await _auth.signOut();
  }

  /// Retrieves the current user's profile.
  Future<Users> getUserDetails() async {
    final User currentUser = _auth.currentUser!;

    final DocumentSnapshot snapshot = await _firestore
        .collection('users')
        .doc(currentUser.uid)
        .get();

    return Users.fromSnap(snapshot);
  }
}
