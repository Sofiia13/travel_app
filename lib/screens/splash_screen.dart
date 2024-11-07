import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 224, 239, 255),
      body: Center(
        child: SizedBox(
          width: 270,
          height: 270,
          child: Image.asset(
            'lib/assets/images/logo_new.png',
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
