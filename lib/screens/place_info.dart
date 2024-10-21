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

  @override
  void dispose() {
    _dateController.dispose();
    _startTimeController.dispose();
    _endTimeController.dispose();
    super.dispose();
  }

  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _startTimeController = TextEditingController();
  final TextEditingController _endTimeController = TextEditingController();

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

  Future<void> _selectStartTime() async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      initialEntryMode: TimePickerEntryMode.dial,
    );

    if (pickedTime != null) {
      setState(() {
        _startTimeController.text = pickedTime.format(context);
      });
      print("Selected time: ${_startTimeController.text}");
    }
  }

  Future<void> _selectEndTime() async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      initialEntryMode: TimePickerEntryMode.dial,
    );

    TimeOfDay? startTime = _getTimeOfDayFromString(_startTimeController.text);

    if (pickedTime != null && startTime != null) {
      // Compare total minutes of picked end time and start time
      if (_timeToMinutes(pickedTime) > _timeToMinutes(startTime)) {
        setState(() {
          _endTimeController.text = pickedTime.format(context);
        });
        print("Selected end time: ${_endTimeController.text}");
      } else {
        // Show a message if the end time is not valid
        Text('End time cannot be earlier than start time.');
        print("End time cannot be earlier than start time.");
        // You could also show a dialog or a SnackBar for user feedback
      }
    }
  }

  int _timeToMinutes(TimeOfDay time) {
    return time.hour * 60 + time.minute;
  }

  TimeOfDay? _getTimeOfDayFromString(String timeString) {
    if (timeString.isEmpty) return null;

    final timeParts = timeString.split(':');
    if (timeParts.length != 2) return null;

    final hour = int.parse(timeParts[0]);
    final minute = int.parse(timeParts[1]);

    return TimeOfDay(hour: hour, minute: minute);
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
                        TextField(
                          controller: _startTimeController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Start time',
                            filled: true,
                            prefixIcon: Icon(Icons.timer_outlined),
                          ),
                          readOnly: true,
                          onTap: () {
                            _selectStartTime();
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextField(
                          controller: _endTimeController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'End time',
                            filled: true,
                            prefixIcon: Icon(Icons.timer_outlined),
                          ),
                          readOnly: true,
                          onTap: () {
                            _selectEndTime();
                          },
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
