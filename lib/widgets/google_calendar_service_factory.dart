import 'package:flutter/foundation.dart'; // For kIsWeb check
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/calendar/v3.dart';
import 'package:googleapis_auth/auth_io.dart'; // For GoogleAuthClient
import 'dart:io' show Platform;
import 'package:http/http.dart' as http;

class GoogleCalendarService {
  final GoogleSignIn googleSignInCredentials;

  GoogleCalendarService({required this.googleSignInCredentials});

  Future<CalendarApi?> signInAndGetCalendarApi() async {
    try {
      final GoogleSignInAccount? account =
          await googleSignInCredentials.signIn();

      if (account == null) {
        print('Google sign-in canceled by user.');
        return null;
      }

      // Get the authentication credentials
      final GoogleSignInAuthentication googleAuth =
          await account.authentication;

      // Create an authenticated client using the access token
      final AuthClient authClient = authenticatedClient(
        http.Client(),
        AccessCredentials(
          AccessToken(
            'Bearer',
            googleAuth.accessToken!,
            DateTime.now().add(Duration(hours: 1)),
          ),
          null,
          ['https://www.googleapis.com/auth/calendar'],
        ),
      );

      // Return the Calendar API object
      return CalendarApi(authClient);
    } catch (e) {
      print('Error signing in and getting Calendar API: $e');
      return null;
    }
  }
}

class GoogleCalendarServiceFactory {
  static GoogleCalendarService create() {
    if (kIsWeb) {
      // Web OAuth client ID
      return GoogleCalendarService(
        googleSignInCredentials: GoogleSignIn(
          clientId:
              '278388737195-srsc36jfsjho66vaf1r18k63n5ai20u0.apps.googleusercontent.com',
          scopes: <String>[CalendarApi.calendarScope],
        ),
      );
    } else if (Platform.isAndroid) {
      // No client ID required for Android
      return GoogleCalendarService(
        googleSignInCredentials: GoogleSignIn(
          scopes: <String>[CalendarApi.calendarScope],
        ),
      );

      // } else if (Platform.isIOS) {
      //   // iOS OAuth client ID
      //   return GoogleCalendarService(
      //     googleSignInCredentials: GoogleSignIn(
      //       clientId: 'YOUR_IOS_CLIENT_ID', // Replace with your iOS client ID
      //       scopes: <String>[CalendarApi.calendarScope],
      //     ),
      //   );
    } else {
      throw Exception('Unsupported platform');
    }
  }
}
