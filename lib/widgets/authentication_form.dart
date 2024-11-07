import 'package:flutter/material.dart';

class AuthenticationForm extends StatelessWidget {
  const AuthenticationForm({
    super.key,
    required this.formKey,
    required this.onEmailChanged,
    required this.onPasswordChanged,
    required this.authenticateUser,
    required this.buttonText,
    required this.onTogglePasswordVisibility,
    required this.isPasswordVisible,
    required this.navigateToSignup,
  });

  final GlobalKey<FormState> formKey;
  final void Function(String) onEmailChanged;
  final void Function(String) onPasswordChanged;
  final void Function() authenticateUser;
  final String buttonText;
  final void Function() onTogglePasswordVisibility;
  final bool isPasswordVisible;
  final void Function() navigateToSignup;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          children: [
            const SizedBox(height: 80),
            Text(
              "Welcome back",
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 10),
            Text(
              "Login to your account",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 40),
            Form(
              key: formKey,
              child: Column(
                children: [
                  // Username TextFormField
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: "Username",
                      prefixIcon: const Icon(Icons.person_outline),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    onChanged: onEmailChanged,
                    validator: (value) => value == null || value.isEmpty
                        ? "Please enter username."
                        : null,
                  ),
                  const SizedBox(height: 10),
                  // Password TextFormField
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: "Password",
                      prefixIcon: const Icon(Icons.password_outlined),
                      suffixIcon: IconButton(
                        onPressed: onTogglePasswordVisibility,
                        icon: Icon(isPasswordVisible
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    obscureText: !isPasswordVisible,
                    keyboardType: TextInputType.visiblePassword,
                    onChanged: onPasswordChanged,
                    validator: (value) => value == null || value.isEmpty
                        ? "Please enter password."
                        : null,
                  ),
                  const SizedBox(height: 40),
                  // Authentication Button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 159, 199, 231),
                      minimumSize: const Size.fromHeight(50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 5,
                    ),
                    onPressed: authenticateUser,
                    child: Text(
                      buttonText,
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account?"),
                      TextButton(
                        onPressed: navigateToSignup,
                        child: const Text("Signup"),
                      ),
                    ],
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
