import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../methods/auth_methods.dart';

class AddPicture extends StatefulWidget {
  final String email;
  final String password;
  final String username;

  const AddPicture({
    super.key,
    required this.email,
    required this.password,
    required this.username,
  });

  @override
  State<AddPicture> createState() => _AddPictureState();
}

class _AddPictureState extends State<AddPicture> {
  Uint8List? _image;

  /// Picks an image from the given source and stores it locally.
  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source);

    if (image == null) return;

    final Uint8List bytes = await image.readAsBytes();

    setState(() {
      _image = bytes;
    });
  }

  /// Completes signup with the selected profile picture.
  Future<void> _completeSignup() async {
    await AuthMethode().signUpUser(
      email: widget.email,
      password: widget.password,
      username: widget.username,
      file: _image,
    );

    if (!mounted) return;

    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          height: screenHeight,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Holbegram',
                style: TextStyle(fontFamily: 'Billabong', fontSize: 50),
              ),

              Image.asset('assets/images/logo.png', width: 80, height: 60),

              const SizedBox(height: 42),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hello, ${widget.username} Welcome to\nHolbegram.',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Choose an image from your gallery or take a new one.',
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              _image == null
                  ? Image.network(
                      'https://upload.wikimedia.org/wikipedia/commons/9/99/Sample_User_Icon.png',
                      width: 170,
                      height: 170,
                      fit: BoxFit.contain,
                    )
                  : ClipOval(
                      child: Image.memory(
                        _image!,
                        width: 170,
                        height: 170,
                        fit: BoxFit.cover,
                      ),
                    ),

              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () => _pickImage(ImageSource.gallery),
                    icon: const Icon(
                      Icons.photo_library_outlined,
                      color: Color.fromARGB(218, 226, 37, 24),
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: 64),
                  IconButton(
                    onPressed: () => _pickImage(ImageSource.camera),
                    icon: const Icon(
                      Icons.photo_camera_outlined,
                      color: Color.fromARGB(218, 226, 37, 24),
                      size: 32,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: 120,
                height: 40,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(
                      const Color.fromARGB(218, 226, 37, 24),
                    ),
                  ),
                  onPressed: _completeSignup,
                  child: const Text(
                    'Next',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
