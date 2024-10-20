import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:travel_app/screens/signup.dart';
import 'package:travel_app/screens/tabs.dart';
import 'package:travel_app/widgets/authentication_form.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final _formKey = GlobalKey<FormState>();

  String emailAddress = '';
  String password = '';

  void signInWithEmailAndPassword() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        final credential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: emailAddress, password: password);

        _goToHomePage(context);
      } on FirebaseAuthException catch (e) {
        // Handle specific error codes
        String errorMessage;
        switch (e.code) {
          case 'user-not-found':
            errorMessage =
                'No user found for that email. Please check your email.';
            break;
          case 'wrong-password':
            errorMessage = 'Incorrect password. Please try again.';
            break;
          case 'invalid-email':
            errorMessage = 'The email address is not valid.';
            break;
          case 'invalid-credential':
            errorMessage = 'The email address or password is not valid.';
            break;
          case 'user-disabled':
            errorMessage = 'This user account has been disabled.';
            break;
          case 'too-many-requests':
            errorMessage = 'Too many requests. Please try again later.';
            break;
          default:
            errorMessage = 'An unexpected error occurred. Please try again.';
        }
        print('FirebaseAuthException: ${e.code}, Message: ${e.message}');

        showMessage(errorMessage); // Use the custom message
      } catch (e) {
        // Handle other exceptions
        showMessage('An unexpected error occurred: $e');
      }
    }
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3),
      ),
    );
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

  void _goToHomePage(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (ctx) => const TabsScreen(),
      ),
    );
  }

  void _goToSignUp(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (ctx) => const SignUpScreen(),
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
              authenticateUser: signInWithEmailAndPassword,
              formKey: _formKey,
              onEmailChanged: updateEmail,
              onPasswordChanged: updatePassword,
              buttonText: 'Login',
              goTo: () {
                // _goToHomePage(context);
              },
            ),
            const SizedBox(height: 20),
            RichText(
              text: TextSpan(
                text: "If you don't have an account, please ",
                style: const TextStyle(color: Colors.black),
                children: [
                  TextSpan(
                    text: 'Sign up',
                    style: const TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        _goToSignUp(context);
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
