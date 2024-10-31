import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:travel_app/screens/create_journey.dart';
import 'package:travel_app/screens/logIn.dart';
import 'package:travel_app/screens/tabs.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 58, 135, 183)),
        textTheme: TextTheme(
          displayLarge: const TextStyle(
            fontSize: 72,
            fontWeight: FontWeight.bold,
          ),
          // ···
          titleLarge: GoogleFonts.barlow(
            fontSize: 25,
            // fontStyle: FontStyle.italic,
          ),
          bodyMedium: GoogleFonts.notoSans(),
          displaySmall: GoogleFonts.pacifico(),
        ),
      ),
      // home: const TabsScreen(),
      home: FirebaseAuth.instance.currentUser == null
          ? const LogInScreen()
          : const CreateJourneyScreen(),
      // home: const LogInScreen(),
    );
  }
}
