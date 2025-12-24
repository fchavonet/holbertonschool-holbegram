import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Feed extends StatelessWidget {
  const Feed({super.key});

  @override
  Widget build(BuildContext context) {
    final String userId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('posts')
              .orderBy('datePublished', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text(
                  'No posts yet',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              );
            }

            final posts = snapshot.data!.docs;

            return StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(userId)
                  .snapshots(),
              builder: (context, userSnapshot) {
                if (!userSnapshot.hasData) {
                  return const SizedBox();
                }

                final userData =
                    userSnapshot.data!.data() as Map<String, dynamic>;
                final saved = List<String>.from(userData['saved'] ?? []);

                return ListView.builder(
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    final postDoc = posts[index];
                    final data = postDoc.data() as Map<String, dynamic>;
                    final postId = postDoc.id;

                    final likes = List<String>.from(data['likes'] ?? []);
                    final isLiked = likes.contains(userId);
                    final isSaved = saved.contains(postId);

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 👤 HEADER
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 18,
                                backgroundImage:
                                    data['profImage'] != null &&
                                        data['profImage'].toString().isNotEmpty
                                    ? NetworkImage(data['profImage'])
                                    : null,
                                child:
                                    data['profImage'] == null ||
                                        data['profImage'].toString().isEmpty
                                    ? const Icon(Icons.person)
                                    : null,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                data['username'] ?? 'Unknown',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Spacer(),
                              const Icon(Icons.more_vert),
                            ],
                          ),
                        ),

                        // 📝 CAPTION
                        if (data['caption'] != null &&
                            data['caption'].toString().isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 4,
                            ),
                            child: Center(
                              child: Text(
                                data['caption'],
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),

                        // 🖼️ IMAGE
                        AspectRatio(
                          aspectRatio: 1,
                          child: Image.network(
                            data['postUrl'],
                            fit: BoxFit.cover,
                          ),
                        ),

                        // ❤️ ACTIONS
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          child: Row(
                            children: [
                              // ❤️ LIKE
                              IconButton(
                                icon: Icon(
                                  isLiked
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: isLiked ? Colors.red : null,
                                ),
                                onPressed: () async {
                                  final postRef = FirebaseFirestore.instance
                                      .collection('posts')
                                      .doc(postId);

                                  if (isLiked) {
                                    await postRef.update({
                                      'likes': FieldValue.arrayRemove([userId]),
                                    });
                                  } else {
                                    await postRef.update({
                                      'likes': FieldValue.arrayUnion([userId]),
                                    });
                                  }
                                },
                              ),

                              // 💬 COMMENT (UI only)
                              IconButton(
                                icon: const Icon(Icons.comment_outlined),
                                onPressed: () {},
                              ),

                              // ✈️ SHARE (UI only)
                              IconButton(
                                icon: const Icon(Icons.send_outlined),
                                onPressed: () {},
                              ),

                              const Spacer(),

                              // 🔖 BOOKMARK (FAVORITE)
                              IconButton(
                                icon: Icon(
                                  isSaved
                                      ? Icons.bookmark
                                      : Icons.bookmark_border,
                                ),
                                onPressed: () async {
                                  final userRef = FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(userId);

                                  if (isSaved) {
                                    await userRef.update({
                                      'saved': FieldValue.arrayRemove([postId]),
                                    });
                                  } else {
                                    await userRef.update({
                                      'saved': FieldValue.arrayUnion([postId]),
                                    });
                                  }
                                },
                              ),
                            ],
                          ),
                        ),

                        // ❤️ LIKES COUNT
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 2,
                          ),
                          child: Text(
                            '${likes.length} liked',
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),

                        const SizedBox(height: 12),
                      ],
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
