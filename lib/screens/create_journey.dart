import 'package:firebase_auth/firebase_auth.dart';
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
  String currentUser = FirebaseAuth.instance.currentUser!.email.toString();

  void _addJourney(String journeyName, List<String> attendees) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("journeys").push();

    String journeyId = ref.key!;

    await ref.set({
      'journeyName': journeyName,
      'organizatorName': currentUser,
      'partners': attendees,
    });

    setState(() {
      journeys.insert(0, {
        'journeyId': journeyId,
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
      print("Raw data from Firebase: $data"); // Log the raw data

      if (data is Map<dynamic, dynamic>) {
        journeys = []; // Clear the existing journeys

        data.forEach((key, value) {
          if (value is Map<dynamic, dynamic>) {
            final journeyData = value;

            final journeyName =
                journeyData['journeyName'] as String? ?? 'Unnamed Journey';
            final organizerName = journeyData['organizatorName'] as String? ??
                'Unknown Organizer';
            final partners = journeyData['partners'] as List<dynamic>? ?? [];
            final attendees = partners.map((email) => email as String).toList();

            // Check if the current user is either the organizer or in the partners list
            if (organizerName == currentUser ||
                attendees.contains(currentUser)) {
              journeys.add({
                'journeyName': journeyName,
                'organizerName': organizerName,
                'attendees': attendees,
              });
            }
          }
        });
      } else {
        print("Data is not a Map: $data");
      }

      // Check the journeys after fetching
      print("Fetched journeys: $journeys"); // Log the journeys list
    }).catchError((error) {
      print("Error fetching journeys: $error");
    });
  }

  @override
  void initState() {
    super.initState();

    if (FirebaseAuth.instance.currentUser != null) {
      journeys = [];
      FirebaseDatabase.instance.ref("journeys").onValue.listen((event) {
        final data = event.snapshot.value as Map<dynamic, dynamic>?;

        journeys = data?.entries.where((entry) {
              final value = entry.value as Map<dynamic, dynamic>;
              return value['organizatorName'] == currentUser ||
                  (value['partners'] as List<dynamic>?)
                          ?.contains(currentUser) ==
                      true;
            }).map((entry) {
              final value = entry.value as Map<dynamic, dynamic>;
              return {
                'journeyName': value['journeyName'] ?? 'Unnamed Journey',
                'organizerName':
                    value['organizatorName'] ?? 'Unknown Organizer',
                'attendees': List<String>.from(value['partners'] ?? []),
              };
            }).toList() ??
            [];

        setState(() {}); // Update the UI when data changes
      });
    } else {
      print("User is not logged in.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create your journey'),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  FirebaseAuth.instance.currentUser!.email.toString(),
                  style: const TextStyle(fontSize: 21),
                ),
              ),
            ),
            ListTile(
              title: const Text('Dummy data'),
              onTap: () {},
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          CreateJourneyForm(onSubmit: _addJourney),
          Expanded(
            child: journeys.isEmpty // Check if journeys list is empty
                ? Center(
                    child:
                        Text('No journeys found.')) // Show a message if empty
                : ListView.builder(
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
