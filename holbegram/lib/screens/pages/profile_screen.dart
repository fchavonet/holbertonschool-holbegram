import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    final String userId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      body: SafeArea(
        child: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .snapshots(),
          builder: (context, userSnapshot) {
            if (userSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!userSnapshot.hasData ||
                userSnapshot.data == null ||
                userSnapshot.data!.data() == null) {
              return const Center(child: Text('User not found'));
            }

            final userData = userSnapshot.data!.data() as Map<String, dynamic>;

            final String username =
                (userData['username'] ?? 'Unknown') as String;
            final String photoUrl = (userData['photoUrl'] ?? '') as String;
            final List followers = userData['followers'] ?? [];
            final List following = userData['following'] ?? [];

            final postsQuery = FirebaseFirestore.instance
                .collection('posts')
                .where('username', isEqualTo: username);

            return Column(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Profile',
                      style: TextStyle(fontFamily: 'Billabong', fontSize: 32),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundImage: photoUrl.isNotEmpty
                            ? NetworkImage(photoUrl)
                            : null,
                        child: photoUrl.isEmpty
                            ? const Icon(Icons.person, size: 40)
                            : null,
                      ),
                      const SizedBox(width: 24),

                      Expanded(
                        child: StreamBuilder<QuerySnapshot>(
                          stream: postsQuery.snapshots(),
                          builder: (context, postSnapshot) {
                            final int postCount = postSnapshot.hasData
                                ? postSnapshot.data!.docs.length
                                : 0;

                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _StatColumn(value: postCount, label: 'posts'),
                                _StatColumn(
                                  value: followers.length,
                                  label: 'followers',
                                ),
                                _StatColumn(
                                  value: following.length,
                                  label: 'following',
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      username,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: postsQuery.snapshots(),
                    builder: (context, postSnapshot) {
                      if (postSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (!postSnapshot.hasData ||
                          postSnapshot.data == null ||
                          postSnapshot.data!.docs.isEmpty) {
                        return const Center(child: Text('No posts yet'));
                      }

                      final posts = postSnapshot.data!.docs;

                      return MasonryGridView.count(
                        crossAxisCount: 3,
                        mainAxisSpacing: 2,
                        crossAxisSpacing: 2,
                        itemCount: posts.length,
                        itemBuilder: (context, index) {
                          final data =
                              posts[index].data() as Map<String, dynamic>;
                          final String url = (data['postUrl'] ?? '') as String;

                          return AspectRatio(
                            aspectRatio: 1, // ✅ FORMAT CARRÉ
                            child: Image.network(url, fit: BoxFit.cover),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _StatColumn extends StatelessWidget {
  final int value;
  final String label;

  const _StatColumn({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value.toString(),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.black54)),
      ],
    );
  }
}
