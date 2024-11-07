import 'package:flutter/material.dart';
import 'package:travel_app/widgets/google_calendar_service_factory.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  GoogleCalendarService? _calendarService;

  @override
  void initState() {
    super.initState();
    _initializeCalendarService();
  }

  void _initializeCalendarService() async {
    final service = GoogleCalendarServiceFactory.create();
    final calendarApi = await service.signInAndGetCalendarApi();

    if (calendarApi != null) {
      print("Successfully authenticated and obtained Calendar API");
    } else {
      print("Failed to authenticate");
    }

    setState(() {
      _calendarService = service;
    });
  }

  Future<void> _signOutAndSignIn() async {
    if (_calendarService != null) {
      await _calendarService!.signOut();
    }
    _initializeCalendarService();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Google Calendar"),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _signOutAndSignIn,
          ),
        ],
      ),
      body: Center(
        child: _calendarService == null
            ? CircularProgressIndicator()
            : Text("Google Calendar Service Initialized"),
      ),
    );
  }
}
