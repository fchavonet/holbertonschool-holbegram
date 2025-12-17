import 'package:flutter/material.dart';
import '../widgets/text_field.dart';
import 'login_screen.dart';

// ignore: must_be_immutable
class SignUp extends StatefulWidget {
  final TextEditingController emailController;
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final TextEditingController passwordConfirmController;
  bool _passwordVisible = true;

  SignUp({
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
  @override
  void initState() {
    super.initState();
    widget._passwordVisible = true;
  }

  @override
  void dispose() {
    widget.emailController.dispose();
    widget.usernameController.dispose();
    widget.passwordController.dispose();
    widget.passwordConfirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
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
                      ispassword: false,
                      hintText: 'Email',
                      keyboardType: TextInputType.emailAddress,
                      suffixIcon: null,
                    ),

                    const SizedBox(height: 16),

                    TextFieldInput(
                      controller: widget.usernameController,
                      ispassword: false,
                      hintText: 'Full Name',
                      keyboardType: TextInputType.text,
                      suffixIcon: null,
                    ),

                    const SizedBox(height: 16),

                    TextFieldInput(
                      controller: widget.passwordController,
                      ispassword: !widget._passwordVisible,
                      hintText: 'Password',
                      keyboardType: TextInputType.visiblePassword,
                      suffixIcon: IconButton(
                        icon: Icon(
                          widget._passwordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: const Color.fromARGB(218, 226, 37, 24),
                        ),
                        onPressed: () {
                          setState(() {
                            widget._passwordVisible = !widget._passwordVisible;
                          });
                        },
                      ),
                    ),

                    const SizedBox(height: 16),

                    TextFieldInput(
                      controller: widget.passwordConfirmController,
                      ispassword: !widget._passwordVisible,
                      hintText: 'Confirm Password',
                      keyboardType: TextInputType.visiblePassword,
                      suffixIcon: IconButton(
                        icon: Icon(
                          widget._passwordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: const Color.fromARGB(218, 226, 37, 24),
                        ),
                        onPressed: () {
                          setState(() {
                            widget._passwordVisible = !widget._passwordVisible;
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
                        onPressed: () {},
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
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginScreen(
                                  emailController: TextEditingController(),
                                  passwordController: TextEditingController(),
                                ),
                              ),
                            );
                          },
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
