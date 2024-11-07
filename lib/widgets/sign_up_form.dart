import 'package:flutter/material.dart';

class SignUpForm extends StatefulWidget {
  SignUpForm({
    super.key,
    required this.formKey,
    required this.onEmailChanged,
    required this.onPasswordChanged,
    required this.authenticateUser,
    required this.buttonText,
    required this.navigateToLogin,
  });

  final GlobalKey<FormState> formKey;
  final void Function(String) onEmailChanged;
  final void Function(String) onPasswordChanged;
  final void Function() authenticateUser;
  final String buttonText;
  final void Function() navigateToLogin;

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final TextEditingController _controllerPassword = TextEditingController();
  final TextEditingController _controllerConfirmPassword =
      TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  void _toggleConfirmPasswordVisibility() {
    setState(() {
      _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Column(
          children: [
            const SizedBox(height: 100),
            Text(
              "Register",
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 10),
            Text(
              "Create your account",
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
              onChanged: widget.onEmailChanged,
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return "Please enter email.";
                } else if (!(value.contains('@') && value.contains('.'))) {
                  return "Invalid email";
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _controllerPassword,
              obscureText: !_isPasswordVisible,
              decoration: InputDecoration(
                labelText: "Password",
                prefixIcon: const Icon(Icons.password_outlined),
                suffixIcon: IconButton(
                  onPressed: _togglePasswordVisibility,
                  icon: _isPasswordVisible
                      ? const Icon(Icons.visibility_outlined)
                      : const Icon(Icons.visibility_off_outlined),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: widget.onPasswordChanged,
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return "Please enter password.";
                } else if (value.length < 8) {
                  return "Password must be at least 8 characters.";
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _controllerConfirmPassword,
              obscureText: !_isConfirmPasswordVisible,
              decoration: InputDecoration(
                labelText: "Confirm Password",
                prefixIcon: const Icon(Icons.password_outlined),
                suffixIcon: IconButton(
                  onPressed: _toggleConfirmPasswordVisibility,
                  icon: _isConfirmPasswordVisible
                      ? const Icon(Icons.visibility_outlined)
                      : const Icon(Icons.visibility_off_outlined),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return "Please enter password.";
                } else if (value != _controllerPassword.text) {
                  return "Password doesn't match.";
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
              onPressed: widget.authenticateUser,
              child: Text(
                widget.buttonText,
                style: const TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Already have an account?"),
                TextButton(
                  onPressed: widget.navigateToLogin,
                  child: const Text("Login"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
