import 'package:flutter/material.dart';
import 'package:googleapis/calendar/v3.dart';
import 'package:intl/intl.dart';
import 'package:travel_app/widgets/create_event_dialog.dart';
import 'package:travel_app/widgets/google_calendar_service_factory.dart';

class PlaceInfoScreen extends StatefulWidget {
  const PlaceInfoScreen({
    super.key,
    required this.placeName,
    required this.location,
    required this.googleCalendarService,
  });

  final String placeName;
  final String location;
  final GoogleCalendarService googleCalendarService;

  @override
  State<PlaceInfoScreen> createState() => _PlaceInfoScreenState();
}

class _PlaceInfoScreenState extends State<PlaceInfoScreen> {
  GoogleCalendarService? _calendarService;

  @override
  void initState() {
    super.initState();
    _initializeCalendarService();
  }

  void _initializeCalendarService() async {
    final calendarApi =
        await widget.googleCalendarService.signInAndGetCalendarApi();

    if (calendarApi != null) {
      // Successfully authenticated
      print("Successfully authenticated and obtained Calendar API");
      setState(() {
        _calendarService = widget.googleCalendarService;
      });
    } else {
      print("Failed to authenticate");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.placeName),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Some place info'),
            Text('Bla bla bla'),
            CreateEventDialog(
              name: widget.placeName,
              location: widget.location,
              googleCalendarService: widget.googleCalendarService,
            ),
          ],
        ),
      ),
    );
  }
}
