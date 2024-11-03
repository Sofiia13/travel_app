import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/calendar/v3.dart';
import 'package:intl/intl.dart';
import 'package:travel_app/widgets/google_calendar_service_factory.dart';

class CreateEventDialog extends StatefulWidget {
  const CreateEventDialog({
    super.key,
    required this.name,
    required this.location,
    required this.googleCalendarService,
    required this.journeyId,
  });

  final String name;
  final String location;
  final GoogleCalendarService googleCalendarService;
  final String journeyId;

  @override
  State<CreateEventDialog> createState() => _CreateEventDialogState();
}

class _CreateEventDialogState extends State<CreateEventDialog> {
  @override
  void initState() {
    super.initState();
    _calendarService = widget.googleCalendarService;
  }

  GoogleCalendarService? _calendarService;

  List<EventAttendee>? attendees = [];

  final TextEditingController dateController = TextEditingController();
  final TextEditingController startTimeController = TextEditingController();
  final TextEditingController endTimeController = TextEditingController();

  Future<void> createCalendarEvent() async {
    if (_calendarService == null) {
      print('Calendar service is not initialized');
      return;
    }
    // if (attendeeController.text.isNotEmpty) {
    //   _addAttendees(attendeeController.text);
    // }

    DateTime? selectedDate = _getDateFromString(dateController.text);
    TimeOfDay? startTime = _getTimeOfDayFromString(startTimeController.text);
    TimeOfDay? endTime = _getTimeOfDayFromString(endTimeController.text);

    if (selectedDate != null && startTime != null && endTime != null) {
      DateTime startDateTime = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        startTime.hour,
        startTime.minute,
      );

      DateTime endDateTime = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        endTime.hour,
        endTime.minute,
      );

      // Create the calendar event
      try {
        await _calendarService!.createEvent(
          widget.name,
          'Description about the place',
          'Location: ${widget.location}',
          startDateTime,
          endDateTime,
          attendees!.isNotEmpty ? attendees : null,
        );
        print("Event created successfully.");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Event created successfully!'),
            duration: Duration(seconds: 3),
          ),
        );
      } catch (error) {
        print("Failed to create event: $error");
      }
    } else {
      print('Please select a date and both start and end times.');
    }
  }

  int _timeToMinutes(TimeOfDay time) {
    return time.hour * 60 + time.minute;
  }

  DateTime? _getDateFromString(String date) {
    if (date.isEmpty) return null;

    List<String> parts = date.split('-');
    if (parts.length < 3) return null;

    int day = int.parse(parts[0]);
    int month = int.parse(parts[1]);
    int year = int.parse(parts[2]);
    return DateTime(year, month, day);
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
  void dispose() {
    dateController.dispose();
    startTimeController.dispose();
    endTimeController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    DateTime? _picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().toUtc().add(Duration(days: 365)),
    );

    if (_picked != null) {
      setState(() {
        dateController.text = DateFormat('dd-MM-yyyy').format(_picked);
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
        startTimeController.text = pickedTime.format(context);
      });
      print("Selected start time: ${startTimeController.text}");
    }
  }

  Future<void> _selectEndTime() async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      initialEntryMode: TimePickerEntryMode.dial,
    );

    TimeOfDay? startTime = _getTimeOfDayFromString(startTimeController.text);

    if (pickedTime != null && startTime != null) {
      // Compare total minutes of picked end time and start time
      if (_timeToMinutes(pickedTime) > _timeToMinutes(startTime)) {
        setState(() {
          endTimeController.text = pickedTime.format(context);
        });
        print("Selected end time: ${endTimeController.text}");
      } else {
        // Show a message if the end time is not valid
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('End time cannot be earlier than start time.'),
            duration: Duration(seconds: 3),
          ),
        );
        print("End time cannot be earlier than start time.");
      }
    }
  }

  Future<void> receiveAttendees() async {
    final ref = FirebaseDatabase.instance.ref();
    final snapshot = await ref.child('journeys/${widget.journeyId}').get();

    if (snapshot.exists) {
      // Assuming snapshot.value is a Map
      final journeyData = snapshot.value as Map<dynamic, dynamic>;

      // Add organizatorName as an EventAttendee
      final organizatorName = journeyData['organizatorName'] as String?;
      if (organizatorName != null) {
        attendees?.add(EventAttendee(email: organizatorName));
      }

      // Check if partners exist and are a list
      if (journeyData['partners'] is List) {
        for (var partner in journeyData['partners']) {
          if (partner is String) {
            attendees?.add(EventAttendee(email: partner));
          }
        }
      }

      print(attendees?.map((a) => a.email).toList());
    } else {
      print('No data available.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () async => showDialog(
        context: context,
        builder: (BuildContext context) => Dialog(
          child: Container(
            padding: EdgeInsets.all(20),
            margin: const EdgeInsets.all(10),
            width: 200,
            child: ListView(
              shrinkWrap: true,
              children: [
                Text(
                  'Create Event',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: dateController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Date',
                    filled: true,
                    prefixIcon: Icon(Icons.calendar_today),
                  ),
                  readOnly: true,
                  onTap: _selectDate,
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: startTimeController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Start time',
                    filled: true,
                    prefixIcon: Icon(Icons.timer_outlined),
                  ),
                  readOnly: true,
                  onTap: _selectStartTime,
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: endTimeController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'End time',
                    filled: true,
                    prefixIcon: Icon(Icons.timer_outlined),
                  ),
                  readOnly: true,
                  onTap: _selectEndTime,
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Close'),
                    ),
                    OutlinedButton(
                      onPressed: () async {
                        await receiveAttendees();
                        createCalendarEvent();
                        Navigator.pop(context);
                      },
                      child: const Text('Create Event'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 20,
        ),
      ),
      child: Text('Add to Google Calendar'),
    );
  }
}
