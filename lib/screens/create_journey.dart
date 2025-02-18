import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:travel_app/widgets/create_journey_form.dart';
import 'package:travel_app/widgets/journey_cards.dart';
import 'package:travel_app/widgets/google_calendar_service_factory.dart';
import 'package:travel_app/screens/logIn.dart';

class CreateJourneyScreen extends StatefulWidget {
  const CreateJourneyScreen({super.key});

  @override
  State<CreateJourneyScreen> createState() => _CreateJourneyState();
}

class _CreateJourneyState extends State<CreateJourneyScreen> {
  List<Map<String, dynamic>> journeys = [];
  String currentUser = FirebaseAuth.instance.currentUser!.email.toString();
  GoogleCalendarService calendarService = GoogleCalendarServiceFactory.create();

  void _addJourney(String journeyName, List<String> attendees) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("journeys").push();

    int timestamp = DateTime.now().millisecondsSinceEpoch;

    await ref.set({
      'journeyName': journeyName,
      'organizatorName': currentUser,
      'partners': attendees,
      'createdAt': timestamp,
    });
  }

  void _fetchJourneys() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("journeys");

    ref.once().then((DatabaseEvent event) {
      final data = event.snapshot.value;

      if (data is Map<dynamic, dynamic>) {
        List<Map<String, dynamic>> initialJourneys = [];

        data.forEach((key, value) {
          if (value is Map<dynamic, dynamic>) {
            final journeyData = value;

            final journeyName =
                journeyData['journeyName'] as String? ?? 'Unnamed Journey';
            final organizerName = journeyData['organizatorName'] as String? ??
                'Unknown Organizer';
            final partners = journeyData['partners'] as List<dynamic>? ?? [];
            final attendees = partners.map((email) => email as String).toList();
            final createdAt = journeyData['createdAt'] as int? ?? 0;

            if (organizerName == currentUser ||
                attendees.contains(currentUser)) {
              initialJourneys.add({
                'journeyId': key,
                'journeyName': journeyName,
                'organizerName': organizerName,
                'attendees': attendees,
                'createdAt': createdAt,
              });
            }
          }
        });

        initialJourneys
            .sort((a, b) => b['createdAt'].compareTo(a['createdAt']));

        setState(() {
          journeys = initialJourneys;
        });
      } else {
        print("Data is not a Map: $data");
      }
    }).catchError((error) {
      print("Error fetching journeys: $error");
    });
  }

  void signOut(GoogleCalendarService calendarService) async {
    await calendarService.signOut();

    await FirebaseAuth.instance.signOut();
    _goToLoginPage(context);
  }

  void _goToLoginPage(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (ctx) => const LogInScreen(),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    if (FirebaseAuth.instance.currentUser != null) {
      _fetchJourneys();
      _subscribeToJourneys();
    } else {
      print("User is not logged in.");
    }
  }

  void _subscribeToJourneys() {
    final journeyRef = FirebaseDatabase.instance.ref("journeys");

    journeyRef.onValue.listen((event) {
      setState(() {
        _fetchJourneys();
      });

      setState(() {
        journeys = [];
      });
    });
  }

  void deleteJourney(journeyId) async {
    final ref = FirebaseDatabase.instance.ref();
    final journeyRef = ref.child('journeys/$journeyId');

    try {
      await journeyRef.remove();
    } catch (e) {
      print('Failed to remove journey: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create your journey'),
        actions: [
          CreateJourneyForm(onSubmit: _addJourney),
        ],
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
              leading: const Icon(Icons.logout),
              title: const Text('Sign Out'),
              onTap: () {
                signOut(calendarService);
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: journeys.isEmpty
                ? Center(
                    child: Text(
                      'No journeys found.',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: journeys.length,
                    itemBuilder: (context, index) {
                      final journey = journeys[index];
                      final journeyId = journey['journeyId'] as String? ?? '';
                      final journeyName = journey['journeyName'] as String? ??
                          'Unnamed Journey';

                      return Dismissible(
                        key: Key(journeyId),
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Icon(Icons.delete, color: Colors.white),
                          ),
                        ),
                        onDismissed: (direction) {
                          setState(() {
                            journeys.removeAt(index);
                            deleteJourney(journeyId);
                          });

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('$journeyName deleted')),
                          );
                        },
                        child: JourneyCards(
                          name: journeyName,
                          journeyId: journeyId,
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
