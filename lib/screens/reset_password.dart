import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:travel_app/screens/waiting_verification.dart';

class resetPasswordScreen extends StatefulWidget {
  const resetPasswordScreen({super.key});

  @override
  State<resetPasswordScreen> createState() => _resetPasswordScreenState();
}

class _resetPasswordScreenState extends State<resetPasswordScreen> {
  String emailAddress = '';
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    void enterEmail(String email) {
      setState(() {
        emailAddress = email;
      });
    }

    void _goToWaitingPage(BuildContext context) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (ctx) => const WaitingVerificationScreen(),
        ),
      );
    }

    Future<void> sendResetEmail() async {
      try {
        await _auth.sendPasswordResetEmail(email: emailAddress);
        // Show confirmation if email was sent successfully
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Password reset email sent! Check your inbox.'),
          ),
        );
        _goToWaitingPage(context);
      } on FirebaseAuthException catch (e) {
        // Handle errors (e.g., invalid email, no user associated with email)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.message}'),
          ),
        );
      }
    }

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 224, 239, 255),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            const SizedBox(height: 100),
            Text(
              "Reset password",
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 10),
            Text(
              "Enter email address",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 35),
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: "Email",
                prefixIcon: const Icon(Icons.email_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: enterEmail,
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return "Please enter email.";
                } else if (!(value.contains('@') && value.contains('.'))) {
                  return "Invalid email";
                }
                return null;
              },
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 159, 199, 231),
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 5,
              ),
              onPressed: sendResetEmail,
              child: Text(
                'Reset',
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
