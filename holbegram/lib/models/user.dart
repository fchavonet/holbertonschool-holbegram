import 'package:cloud_firestore/cloud_firestore.dart';

class Users {
  // Identity.
  final String uid;
  final String email;
  final String username;

  // Profile.
  final String bio;
  final String photoUrl;
  final String searchKey;

  // Relations / content.
  final List<dynamic> followers;
  final List<dynamic> following;
  final List<dynamic> posts;
  final List<dynamic> saved;

  const Users({
    required this.uid,
    required this.email,
    required this.username,
    required this.bio,
    required this.photoUrl,
    required this.followers,
    required this.following,
    required this.posts,
    required this.saved,
    required this.searchKey,
  });

  /// Creates a Users instance.
  static Users fromSnap(DocumentSnapshot snap) {
    final Map<String, dynamic> data = snap.data() as Map<String, dynamic>;

    return Users(
      uid: data['uid'] ?? '',
      email: data['email'] ?? '',
      username: data['username'] ?? '',
      bio: data['bio'] ?? '',
      photoUrl: data['photoUrl'] ?? '',
      followers: data['followers'] is List ? data['followers'] : [],
      following: data['following'] is List ? data['following'] : [],
      posts: data['posts'] is List ? data['posts'] : [],
      saved: data['saved'] is List ? data['saved'] : [],
      searchKey: data['searchKey'] ?? '',
    );
  }

  /// Converts the Users object to a Firestore-compatible map.
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'username': username,
      'bio': bio,
      'photoUrl': photoUrl,
      'followers': followers,
      'following': following,
      'posts': posts,
      'saved': saved,
      'searchKey': searchKey,
    };
  }
}
