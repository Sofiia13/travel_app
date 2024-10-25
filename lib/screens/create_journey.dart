import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:travel_app/widgets/create_journey_form.dart';

class CreateJourneyScreen extends StatefulWidget {
  const CreateJourneyScreen({super.key});

  @override
  State<CreateJourneyScreen> createState() => _CreateJourneyState();
}

class _CreateJourneyState extends State<CreateJourneyScreen> {
  void _addJourney(String journeyName, List<String> attendees) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("journeys");

    await ref.set({
      'journeyName': journeyName,
      'organizatorName': 'Organizer Name',
      'partners': attendees,
    });

    print(
        "Journey '$journeyName' with attendees $attendees saved to Firebase.");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create your journey'),
      ),
      body: CreateJourneyForm(
        onSubmit: (journeyName, attendees) {
          _addJourney(journeyName, attendees);
        },
      ),
    );
  }
}
