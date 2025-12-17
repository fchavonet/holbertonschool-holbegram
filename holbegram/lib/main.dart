import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'widgets/text_field.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFieldInput(
                controller: emailController,
                ispassword: false,
                hintText: 'Email',
                keyboardType: TextInputType.emailAddress,
                suffixIcon: null,
              ),
              const SizedBox(height: 16),
              TextFieldInput(
                controller: passwordController,
                ispassword: true,
                hintText: 'Password',
                keyboardType: TextInputType.text,
                suffixIcon: const Icon(Icons.visibility_off),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
