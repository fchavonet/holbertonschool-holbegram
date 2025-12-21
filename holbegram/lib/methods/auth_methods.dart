import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

import '../models/user.dart';

class AuthMethode {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// LOGIN
  Future<String> login({
    required String email,
    required String password,
  }) async {
    String res = "Some error occurred";

    try {
      if (email.isEmpty || password.isEmpty) {
        return "Please fill all the fields";
      }

      await _auth.signInWithEmailAndPassword(email: email, password: password);

      res = "success";
    } catch (err) {
      res = err.toString();
    }

    return res;
  }

  /// SIGN UP
  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    Uint8List? file,
  }) async {
    String res = "Some error occurred";

    try {
      if (email.isEmpty || password.isEmpty || username.isEmpty) {
        return "Please fill all the fields";
      }

      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      User user = userCredential.user!;

      Users users = Users(
        uid: user.uid,
        email: email,
        username: username,
        bio: '',
        photoUrl: '',
        followers: [],
        following: [],
        posts: [],
        saved: [],
        searchKey: username[0].toLowerCase(),
      );

      await _firestore.collection("users").doc(user.uid).set(users.toJson());

      res = "success";
    } catch (err) {
      res = err.toString();
    }

    return res;
  }

  Future<Users> getUserDetails() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot snap = await _firestore
        .collection('users')
        .doc(currentUser.uid)
        .get();

    return Users.fromSnap(snap);
  }
}
