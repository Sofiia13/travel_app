import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/calendar/v3.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'dart:io' show Platform;
import 'package:http/http.dart' as http;

class GoogleCalendarService {
  final GoogleSignIn googleSignInCredentials;
  CalendarApi? calendarApi; // Field for CalendarApi

  GoogleCalendarService({required this.googleSignInCredentials});

  Future<CalendarApi?> signInAndGetCalendarApi() async {
    try {
      final GoogleSignInAccount? account =
          await googleSignInCredentials.signIn();

      if (account == null) {
        print('Google sign-in canceled by user.');
        return null;
      }

      print('User email: ${account.email}');

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
            DateTime.now().toUtc().add(Duration(hours: 1)),
          ),
          null,
          ['https://www.googleapis.com/auth/calendar'],
        ),
      );

      calendarApi = CalendarApi(authClient);
      return calendarApi;
    } catch (e) {
      print('Error signing in and getting Calendar API: $e');
      return null;
    }
  }

  Future<void> createEvent(
    String summary,
    String description,
    String location,
    startTime,
    endTime,
    List<EventAttendee>? attendees,
  ) async {
    if (calendarApi == null) {
      print('Calendar API is not initialized. Please sign in first.');
      return;
    }

    try {
      // Create an event
      Event event = Event(
        summary: summary,
        description: description,
        start: EventDateTime(
          dateTime: startTime,
          timeZone: 'UTC',
        ),
        end: EventDateTime(
          dateTime: endTime,
          timeZone: 'UTC',
        ),
        location: location,
        attendees: attendees != null && attendees.isNotEmpty ? attendees : null,
      );

      // Insert the event into the primary calendar
      await calendarApi!.events.insert(event, 'primary');
      print('Event created: ${event.summary}');
    } catch (e) {
      print('Error creating event: $e');
    }
  }

  Future<void> signOut() async {
    await googleSignInCredentials.signOut();
    print('User signed out');
    calendarApi = null; // Reset the calendarApi on sign out
  }
}

class GoogleCalendarServiceFactory {
  static GoogleCalendarService create() {
    if (kIsWeb) {
      // Web OAuth client ID
      return GoogleCalendarService(
        googleSignInCredentials: GoogleSignIn(
          clientId: 'YOUR_WEB_CLIENT_ID',
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
    } else {
      throw Exception('Unsupported platform');
    }
  }
}
