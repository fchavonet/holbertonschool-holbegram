import 'package:flutter/material.dart';

import '../../widgets/text_field.dart';
import './login_screen.dart';
import './upload_image_screen.dart';

class SignUp extends StatefulWidget {
  final TextEditingController emailController;
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final TextEditingController passwordConfirmController;

  const SignUp({
    super.key,
    required this.emailController,
    required this.usernameController,
    required this.passwordController,
    required this.passwordConfirmController,
  });

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool _passwordVisible = false;

  @override
  void dispose() {
    widget.emailController.dispose();
    widget.usernameController.dispose();
    widget.passwordController.dispose();
    widget.passwordConfirmController.dispose();
    super.dispose();
  }

  /// Navigates to the profile picture upload screen.
  void _goToUploadPicture() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddPicture(
          email: widget.emailController.text,
          username: widget.usernameController.text,
          password: widget.passwordController.text,
        ),
      ),
    );
  }

  /// Navigates to the login screen.
  void _goToLogin() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => LoginScreen(
          emailController: TextEditingController(),
          passwordController: TextEditingController(),
        ),
      ),
    );
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

              const SizedBox(height: 16),

              const Text(
                'Sign up to see photos and videos\nfrom your friends.',
                textAlign: TextAlign.center,
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 28),

                    TextFieldInput(
                      controller: widget.emailController,
                      hintText: 'Email',
                      keyboardType: TextInputType.emailAddress,
                      ispassword: false,
                      suffixIcon: null,
                    ),

                    const SizedBox(height: 16),

                    TextFieldInput(
                      controller: widget.usernameController,
                      hintText: 'Full Name',
                      keyboardType: TextInputType.text,
                      ispassword: false,
                      suffixIcon: null,
                    ),

                    const SizedBox(height: 16),

                    TextFieldInput(
                      controller: widget.passwordController,
                      hintText: 'Password',
                      keyboardType: TextInputType.visiblePassword,
                      ispassword: !_passwordVisible,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _passwordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: const Color.fromARGB(218, 226, 37, 24),
                        ),
                        onPressed: () {
                          setState(() {
                            _passwordVisible = !_passwordVisible;
                          });
                        },
                      ),
                    ),

                    const SizedBox(height: 16),

                    TextFieldInput(
                      controller: widget.passwordConfirmController,
                      hintText: 'Confirm Password',
                      keyboardType: TextInputType.visiblePassword,
                      ispassword: !_passwordVisible,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _passwordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: const Color.fromARGB(218, 226, 37, 24),
                        ),
                        onPressed: () {
                          setState(() {
                            _passwordVisible = !_passwordVisible;
                          });
                        },
                      ),
                    ),

                    const SizedBox(height: 28),

                    SizedBox(
                      height: 48,
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(
                            const Color.fromARGB(218, 226, 37, 24),
                          ),
                        ),
                        onPressed: _goToUploadPicture,
                        child: const Text(
                          'Sign up',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Have an account? '),
                        TextButton(
                          onPressed: _goToLogin,
                          child: const Text(
                            'Log in',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(218, 226, 37, 24),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
