import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../methods/auth_methods.dart';
import '../home.dart';
import 'methods/post_storage.dart';

class AddImage extends StatefulWidget {
  const AddImage({super.key});

  @override
  State<AddImage> createState() => _AddImageState();
}

class _AddImageState extends State<AddImage> {
  Uint8List? _image;
  final TextEditingController _captionController = TextEditingController();
  bool _isLoading = false;

  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? picked = await picker.pickImage(source: source);

    if (picked == null) return;

    final bytes = await picked.readAsBytes();
    setState(() {
      _image = bytes;
    });
  }

  Future<void> _post() async {
    if (_image == null) return;

    setState(() {
      _isLoading = true;
    });

    final user = await AuthMethode().getUserDetails();

    final String res = await PostStorage().uploadPost(
      _captionController.text.trim(),
      user.uid,
      user.username,
      user.photoUrl,
      _image!,
    );

    setState(() {
      _isLoading = false;
    });

    if (!mounted) return;

    if (res == "Ok") {
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => const Home()));
    }
  }

  void _showPickOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo),
                title: const Text("Gallery"),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text("Camera"),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _captionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Add Image",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _post,
            child: const Text(
              "Post",
              style: TextStyle(
                fontFamily: "Billabong",
                fontSize: 26,
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),

      body: Column(
        children: [
          if (_isLoading) const LinearProgressIndicator(),

          const SizedBox(height: 24),

          const Text(
            "Add Image",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 8),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              "Choose an image from your gallery or take a one.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),

          const SizedBox(height: 20),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: _captionController,
              decoration: const InputDecoration(
                hintText: "Write a caption...",
                hintStyle: TextStyle(color: Colors.black38),
                border: InputBorder.none,
              ),
            ),
          ),

          const SizedBox(height: 12),

          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 40),
                child: GestureDetector(
                  onTap: _showPickOptions,
                  child: _image == null
                      ? Container(
                          width: 220,
                          height: 220,
                          padding: const EdgeInsets.all(32),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Image.network(
                            "https://cdn.pixabay.com/photo/2017/11/10/05/24/add-2935429_960_720.png",
                            fit: BoxFit.contain,
                          ),
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.memory(
                            _image!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
