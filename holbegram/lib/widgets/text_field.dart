import 'package:flutter/material.dart';

class TextFieldInput extends StatelessWidget {
  final TextEditingController controller;
  final bool ispassword;
  final String hintText;
  final TextInputType keyboardType;
  final Widget? suffixIcon;

  const TextFieldInput({
    super.key,
    required this.controller,
    required this.ispassword,
    required this.hintText,
    required this.keyboardType,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: ispassword,
      textInputAction: TextInputAction.next,
      cursorColor: const Color.fromARGB(218, 226, 37, 24),
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        contentPadding: const EdgeInsets.all(8),
        suffixIcon: suffixIcon == null
            ? null
            : SizedBox(width: 24, height: 24, child: Center(child: suffixIcon)),
        border: _border,
        enabledBorder: _border,
        focusedBorder: _border,
      ),
    );
  }

  /// Shared input border (no visible border).
  static const OutlineInputBorder _border = OutlineInputBorder(
    borderSide: BorderSide(color: Colors.transparent, style: BorderStyle.none),
  );
}
