import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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

  void createCalendarEvent() async {
    GoogleCalendarService calendarService =
        GoogleCalendarServiceFactory.create();

    // Sign in and initialize Calendar API
    await calendarService.signInAndGetCalendarApi();

    // Now create an event, only after sign-in is successful
    await calendarService.createEvent(
      widget.placeName,
      'Description about the place',
      'Location: ${widget.location}',
    );
  }

  @override
  void initState() {
    super.initState();
    _initializeCalendarService();
  }

  TextEditingController _dateController = TextEditingController();

  Future<void> _selectDate() async {
    DateTime? _picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().toUtc().add(Duration(days: 365)),
    );

    if (_picked != null) {
      setState(() {
        _dateController.text = DateFormat('dd-MM-yyyy').format(_picked);
      });
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
            OutlinedButton(
              onPressed: () async => showDialog(
                context: context,
                builder: (BuildContext context) => Dialog(
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    width: 200,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Create Event',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        // DatePickerDialog(
                        //   firstDate: DateTime.now().toUtc(),
                        //   lastDate:
                        //       DateTime.now().toUtc().add(Duration(days: 365)),
                        // ),
                        TextField(
                          controller: _dateController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Date',
                            filled: true,
                            prefixIcon: Icon(Icons.calendar_today),
                          ),
                          readOnly: true,
                          onTap: () {
                            _selectDate();
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const TextField(
                          obscureText: true,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Start time',
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const TextField(
                          obscureText: true,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Duration',
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('close'),
                            ),
                            OutlinedButton(
                              onPressed: () {
                                createCalendarEvent();
                              },
                              child: const Text('Create Event'),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),

              // createCalendarEvent();
              child: Text('Add to Google Calendar'),
            ),
          ],
        ),
      ),
    );
  }
}
