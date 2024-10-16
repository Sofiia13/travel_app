import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          print('No user found for that email.');
        } else if (e.code == 'wrong-password') {
          print('Wrong password provided for that user.');
        }
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

  @override
  Widget build(BuildContext context) {
    // var _isSending = false;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: AuthenticationForm(
          authenticateUser: signInWithEmailAndPassword,
          formKey: _formKey,
          onEmailChanged: updateEmail,
          onPasswordChanged: updatePassword,
        ),
      ),
    );
  }
}
