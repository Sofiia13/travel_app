import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:travel_app/screens/create_journey.dart';
import 'package:travel_app/screens/logIn.dart';
import 'package:travel_app/screens/splash_screen.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _showSplash = true;

  @override
  void initState() {
    super.initState();
    _startSplashScreenTimer();
  }

  void _startSplashScreenTimer() {
    print("Starting splash screen timer...");
    Future.delayed(const Duration(seconds: 6), () {
      setState(() {
        _showSplash = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        scaffoldBackgroundColor: Color.fromARGB(255, 247, 247, 247),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 0, 57, 115),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: const Color.fromARGB(255, 0, 57, 115),
          titleTextStyle: GoogleFonts.roboto(
              fontSize: 25, color: Colors.white, fontStyle: FontStyle.italic),
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
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
          bodyMedium: GoogleFonts.notoSans(fontStyle: FontStyle.italic),
          displaySmall: GoogleFonts.pacifico(),
        ),
      ),

      // home: const TabsScreen(),
      home: _showSplash
          ? const SplashScreen()
          : FirebaseAuth.instance.currentUser == null
              ? const LogInScreen()
              : const CreateJourneyScreen(),
      // home: const LogInScreen(),
    );
  }
}
