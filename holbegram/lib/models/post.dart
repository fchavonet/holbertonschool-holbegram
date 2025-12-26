import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  // Post metadata.
  final String postId;
  final String uid;
  final String username;
  final String caption;

  // Media.
  final String postUrl;
  final String publicId;
  final String profImage;

  // Engagement.
  final List likes;

  // Timestamps.
  final DateTime datePublished;

  const Post({
    required this.postId,
    required this.uid,
    required this.username,
    required this.caption,
    required this.postUrl,
    required this.publicId,
    required this.profImage,
    required this.likes,
    required this.datePublished,
  });

  /// Creates a Post instance.
  static Post fromSnap(DocumentSnapshot snap) {
    final Map<String, dynamic> data = snap.data() as Map<String, dynamic>;

    return Post(
      postId: data['postId'] ?? '',
      uid: data['uid'] ?? '',
      username: data['username'] ?? '',
      caption: data['caption'] ?? '',
      postUrl: data['postUrl'] ?? '',
      publicId: data['publicId'] ?? '',
      profImage: data['profImage'] ?? '',
      likes: data['likes'] is List ? data['likes'] : [],
      datePublished: data['datePublished'] is Timestamp
          ? (data['datePublished'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  /// Converts the Post object to a Firestore-compatible map.
  Map<String, dynamic> toJson() {
    return {
      'postId': postId,
      'uid': uid,
      'username': username,
      'caption': caption,
      'postUrl': postUrl,
      'publicId': publicId,
      'profImage': profImage,
      'likes': likes,
      'datePublished': datePublished,
    };
  }
}
