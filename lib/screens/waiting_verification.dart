import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:travel_app/screens/login.dart';

class WaitingVerificationScreen extends StatefulWidget {
  const WaitingVerificationScreen({super.key});

  @override
  State<WaitingVerificationScreen> createState() =>
      _WaitingVerificationScreenState();
}

class _WaitingVerificationScreenState extends State<WaitingVerificationScreen> {
  @override
  void initState() {
    super.initState();
    // Start checking for email verification when the screen is shown
    checkEmailVerification();
  }

  void checkEmailVerification() async {
    User? user = FirebaseAuth.instance.currentUser;
    await user?.reload();

    if (user != null) {
      if (user.emailVerified) {
        print('Email is verified');
        _goToLoginPage(context); // Redirect to login
      } else {
        print('Email is not verified yet.');
        Future.delayed(const Duration(seconds: 3), () {
          if (mounted) {
            checkEmailVerification(); // Retry verification check
          }
        });
      }
    } else {
      print('No user found');
    }
  }

  void _goToLoginPage(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (ctx) => const LogInScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 224, 239, 255),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Animated icon for loading
            Icon(
              Icons.mail_outline_outlined,
              size: 80,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 15),
            // Text with more styling
            Text(
              'Check your email box',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 15),
            // Subtext
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                'We have sent a verification email to your inbox. Please confirm your email to proceed.',
                style: TextStyle(
                  fontSize: 15,
                  color: Theme.of(context).colorScheme.primary,
                  letterSpacing: 0.5,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
