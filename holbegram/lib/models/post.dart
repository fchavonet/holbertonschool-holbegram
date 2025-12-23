import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String caption;
  final String uid;
  final String username;
  final List likes;
  final String postId;
  final String publicId;
  final DateTime datePublished;
  final String postUrl;
  final String profImage;

  const Post({
    required this.caption,
    required this.uid,
    required this.username,
    required this.likes,
    required this.postId,
    required this.publicId,
    required this.datePublished,
    required this.postUrl,
    required this.profImage,
  });

  static Post fromSnap(DocumentSnapshot snap) {
    final Map<String, dynamic> data = snap.data() as Map<String, dynamic>;

    DateTime published = DateTime.now();
    final dynamic rawDate = data['datePublished'];
    if (rawDate is Timestamp) {
      published = rawDate.toDate();
    }

    List likesList = [];
    final dynamic rawLikes = data['likes'];
    if (rawLikes is List) {
      likesList = rawLikes;
    }

    return Post(
      caption: (data['caption'] ?? '') as String,
      uid: (data['uid'] ?? '') as String,
      username: (data['username'] ?? '') as String,
      likes: likesList,
      postId: (data['postId'] ?? '') as String,
      publicId: (data['publicId'] ?? '') as String,
      datePublished: published,
      postUrl: (data['postUrl'] ?? '') as String,
      profImage: (data['profImage'] ?? '') as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'caption': caption,
      'uid': uid,
      'username': username,
      'likes': likes,
      'postId': postId,
      'publicId': publicId,
      'datePublished': datePublished,
      'postUrl': postUrl,
      'profImage': profImage,
    };
  }
}
