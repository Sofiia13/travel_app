import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:travel_app/widgets/create_journey_form.dart';
import 'package:travel_app/widgets/journey_cards.dart';

class CreateJourneyScreen extends StatefulWidget {
  const CreateJourneyScreen({super.key});

  @override
  State<CreateJourneyScreen> createState() => _CreateJourneyState();
}

class _CreateJourneyState extends State<CreateJourneyScreen> {
  List<Map<String, dynamic>> journeys = [];

  void _addJourney(String journeyName, List<String> attendees) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("journeys").push();

    await ref.set({
      'journeyName': journeyName,
      'organizatorName': 'Organizer Name',
      'partners': attendees,
    });

    setState(() {
      journeys.insert(0, {
        'journeyName': journeyName,
      });
    });

    print(
        "Journey '$journeyName' with attendees $attendees saved to Firebase.");
  }

  void _fetchJourneys() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("journeys");

    ref.once().then((DatabaseEvent event) {
      final data = event.snapshot.value;
      print("Raw data from Firebase: $data"); // Debugging

      if (data is Map<dynamic, dynamic>) {
        // Check if data is a Map
        journeys = []; // Initialize journeys as an empty list

        data.forEach((key, value) {
          if (value is Map<dynamic, dynamic>) {
            // Check if the value is a Map
            final journeyData = value;

            // Safely get the journey name
            final journeyName =
                journeyData['journeyName'] as String? ?? 'Unnamed Journey';
            final organizerName = journeyData['organizatorName'] as String? ??
                'Unknown Organizer';

            // Safely get partners, default to empty list if null
            final partners = journeyData['partners'] as List<dynamic>? ?? [];
            final attendees = partners.map((email) => email as String).toList();

            journeys.add({
              'journeyName': journeyName,
              'organizerName': organizerName,
              'attendees': attendees, // List of strings for emails
            });
          }
        });
      } else {
        print("Data is not a Map: $data"); // Log if data is not a Map
      }
      setState(() {}); // Update the UI
    }).catchError((error) {
      print("Error fetching journeys: $error"); // Log errors
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchJourneys();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create your journey'),
      ),
      body: Column(
        children: [
          CreateJourneyForm(onSubmit: _addJourney),
          Expanded(
            child: ListView.builder(
              itemCount: journeys.length,
              itemBuilder: (context, index) {
                final journey = journeys[index];
                return JourneyCards(name: journey['journeyName']);
              },
            ),
          ),
        ],
      ),
    );
  }
}
