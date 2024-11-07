import 'package:flutter/material.dart';

class CreateJourneyForm extends StatefulWidget {
  const CreateJourneyForm({super.key, required this.onSubmit});

  final Function(String, List<String>) onSubmit;

  @override
  State<CreateJourneyForm> createState() => _CreateJourneyFormState();
}

class _CreateJourneyFormState extends State<CreateJourneyForm> {
  List<String>? attendees = [];
  final TextEditingController attendeeController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  bool hasInvalidEmail = false;

  @override
  void dispose() {
    attendeeController.dispose();
    nameController.dispose();
    super.dispose();
  }

  bool _isValidEmail(String email) {
    final emailRegex =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegex.hasMatch(email);
  }

  void _addAttendees(String emails) {
    attendees?.clear();
    hasInvalidEmail = false;

    if (emails.isNotEmpty) {
      List<String> emailList =
          emails.split(',').map((email) => email.trim()).toList();

      for (String email in emailList) {
        if (_isValidEmail(email)) {
          attendees?.add(email);
          print('Added attendee: $email');
        } else {
          hasInvalidEmail = true;
          print('Invalid email: $email');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Invalid email: $email'),
              duration: Duration(seconds: 3),
            ),
          );
        }
      }
    }
  }

  void _showCreateJourneyDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        child: Container(
          padding: EdgeInsets.all(20),
          margin: const EdgeInsets.all(10),
          width: 300,
          child: ListView(
            shrinkWrap: true,
            children: [
              Text(
                'Create Journey',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Add Journey Name',
                  filled: true,
                  prefixIcon: Icon(Icons.travel_explore),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: attendeeController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Add Attendee Email',
                  filled: true,
                  prefixIcon: Icon(Icons.people_alt),
                ),
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
                    onPressed: () {
                      String journeyName = nameController.text;
                      String emails = attendeeController.text;

                      _addAttendees(emails);

                      if (!hasInvalidEmail) {
                        widget.onSubmit(journeyName, attendees ?? []);
                      }

                      nameController.clear();
                      attendeeController.clear();
                      Navigator.pop(context);
                    },
                    child: const Text('Create Journey'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // return Container(
    //   alignment: Alignment.bottomRight,
    //   padding: EdgeInsets.all(20),
    // decoration: BoxDecoration(
    //     border: Border.all(width: 4),
    //   ),
    return IconButton(
      onPressed: _showCreateJourneyDialog,
      icon: const Icon(Icons.add),
      color: Colors.white, // Change this to your desired color
    );
    // );
  }
}
