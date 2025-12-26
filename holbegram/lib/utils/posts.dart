import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Posts extends StatefulWidget {
  const Posts({super.key});

  @override
  State<Posts> createState() => _PostsState();
}

class _PostsState extends State<Posts> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('posts').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final List<QueryDocumentSnapshot> docs = snapshot.data!.docs;

        return ListView.builder(
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final QueryDocumentSnapshot doc = docs[index];
            final Map<String, dynamic> data =
                doc.data() as Map<String, dynamic>;

            final String username = data['username'] ?? '';
            final String caption = data['caption'] ?? '';
            final String profImage = data['profImage'] ?? '';
            final String postUrl = data['postUrl'] ?? '';

            return Container(
              margin: const EdgeInsets.all(8),
              height: 540,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Column(
                children: [
                  /// Header.
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 40,
                          height: 40,
                          child: ClipOval(
                            child: Image.network(
                              profImage,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) {
                                return Image.network(
                                  'https://upload.wikimedia.org/wikipedia/commons/9/99/Sample_User_Icon.png',
                                  fit: BoxFit.cover,
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          username,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const Spacer(),
                        const Icon(Icons.more_horiz),
                      ],
                    ),
                  ),

                  /// Caption.
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(caption),
                    ),
                  ),

                  const SizedBox(height: 10),

                  /// Image.
                  ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: Image.network(
                      postUrl,
                      width: 350,
                      height: 350,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) {
                        return Container(
                          width: 350,
                          height: 350,
                          color: Colors.black12,
                          child: const Center(
                            child: Icon(Icons.broken_image_outlined),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 10),

                  /// Actions.
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      children: const [
                        Icon(Icons.favorite_border),
                        SizedBox(width: 8),
                        Icon(Icons.mode_comment_outlined),
                        SizedBox(width: 8),
                        Icon(Icons.send_outlined),
                        Spacer(),
                        Icon(Icons.bookmark_border),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
