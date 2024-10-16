import 'package:flutter/material.dart';

class AuthenticationForm extends StatelessWidget {
  const AuthenticationForm({
    super.key,
    required this.authenticateUser,
    required this.formKey,
    required this.onEmailChanged,
    required this.onPasswordChanged,
    required this.buttonText,
  });

  final void Function() authenticateUser;
  final GlobalKey<FormState> formKey;
  final void Function(String) onEmailChanged;
  final void Function(String) onPasswordChanged;
  final String buttonText;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          TextFormField(
            maxLength: 50,
            decoration: const InputDecoration(
              label: Text('Email'),
            ),
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter an email';
              }
              return null;
            },
            onChanged: onEmailChanged,
          ),
          TextFormField(
            maxLength: 50,
            decoration: const InputDecoration(
              label: Text('Password'),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a password';
              } else if (value.length < 6) {
                return 'Password must be at least 6 characters';
              }
              return null; // Input is valid
            },
            onChanged: onPasswordChanged,
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {},
                child: const Text('Reset'),
              ),
              ElevatedButton(
                onPressed: authenticateUser,
                child: Text(buttonText),
              )
            ],
          )
        ],
      ),
    );
  }
}
