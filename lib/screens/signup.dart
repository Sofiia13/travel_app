import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
      _formKey.currentState!.save(); // Save the form data (email, password)
      try {
        final credential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailAddress,
          password: password,
        );
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
          authenticateUser: createUserWithEmailAndPassword,
          formKey: _formKey,
          onEmailChanged: updateEmail,
          onPasswordChanged: updatePassword,
          buttonText: 'SignUp',
        ),
      ),
    );
  }
}
