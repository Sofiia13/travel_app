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
      // You can use calendarApi to fetch or create events
      print("Successfully authenticated and obtained Calendar API");
    } else {
      print("Failed to authenticate");
    }

    setState(() {
      _calendarService = service;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Google Calendar")),
      body: Center(
        child: _calendarService == null
            ? CircularProgressIndicator()
            : Text("Google Calendar Service Initialized"),
      ),
    );
  }
}
