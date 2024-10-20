import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:travel_app/screens/logIn.dart';
import 'package:travel_app/screens/waiting_verification.dart';
import 'package:travel_app/widgets/authentication_form.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  String emailAddress = '';
  String password = '';

  void createUserWithEmailAndPassword() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        final credential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailAddress,
          password: password,
        );
        sendEmailVerification();
        _goToWaitingPage(context);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          print('The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          print('The account already exists for that email.');
        }
      } catch (e) {
        print(e);
      }
    }
  }

  void sendEmailVerification() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null && !user.emailVerified) {
      try {
        await FirebaseAuth.instance.setLanguageCode("fr");
        await user.sendEmailVerification();
        print('Verification email sent');
      } catch (e) {
        print('Failed to send verification email: $e');
      }
    } else {
      if (user == null) {
        print('No user found.');
      } else {
        print('Email is already verified.');
      }
    }
  }

  void updateEmail(String email) {
    setState(() {
      emailAddress = email;
    });
  }

  void updatePassword(String pass) {
    setState(() {
      password = pass;
    });
  }

  void _goToLoginPage(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (ctx) => const LogInScreen(),
      ),
    );
  }

  void _goToWaitingPage(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (ctx) => const WaitingVerificationScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // var _isSending = false;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            AuthenticationForm(
              authenticateUser: createUserWithEmailAndPassword,
              formKey: _formKey,
              onEmailChanged: updateEmail,
              onPasswordChanged: updatePassword,
              buttonText: 'SignUp',
              goTo: () {
                // _goToWaitingPage(context);
              },
            ),
            const SizedBox(height: 20),
            RichText(
              text: TextSpan(
                text: "Already have an account, please ",
                style: const TextStyle(color: Colors.black),
                children: [
                  TextSpan(
                    text: 'Login',
                    style: const TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        _goToLoginPage(context);
                      },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
