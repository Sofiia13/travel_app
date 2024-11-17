import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:travel_app/screens/create_journey.dart';
import 'package:travel_app/screens/reset_password.dart';
import 'package:travel_app/screens/signup.dart';
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
  bool isPasswordVisible = false;

  void signInWithEmailAndPassword() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailAddress,
          password: password,
        );
        _goToHomePage(context);
      } on FirebaseAuthException catch (e) {
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
          case 'user-disabled':
            errorMessage = 'This user account has been disabled.';
            break;
          case 'too-many-requests':
            errorMessage = 'Too many requests. Please try again later.';
            break;
          default:
            errorMessage = 'An unexpected error occurred. Please try again.';
        }
        showMessage(errorMessage);
      } catch (e) {
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

  void _togglePasswordVisibility() {
    setState(() {
      isPasswordVisible = !isPasswordVisible;
    });
  }

  void _goToHomePage(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (ctx) => const CreateJourneyScreen(),
      ),
    );
  }

  void _goToSignUp(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => const SignUpScreen(),
      ),
    );
  }

  void _goToReset(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => const resetPasswordScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 224, 239, 255),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 60),
            AuthenticationForm(
              authenticateUser: signInWithEmailAndPassword,
              formKey: _formKey,
              onEmailChanged: updateEmail,
              onPasswordChanged: updatePassword,
              buttonText: 'Login',
              isPasswordVisible: isPasswordVisible,
              onTogglePasswordVisibility: _togglePasswordVisibility,
              navigateToSignup: () => _goToSignUp(context),
              resetPassword: () => _goToReset(context),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
