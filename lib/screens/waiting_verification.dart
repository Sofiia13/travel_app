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
    return const Scaffold(
      body: Center(
        child: Text('Check your email box'),
      ),
    );
  }
}
