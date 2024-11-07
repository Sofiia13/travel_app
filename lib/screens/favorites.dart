import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:travel_app/screens/place_info.dart';
import 'package:travel_app/widgets/google_calendar_service_factory.dart';

class FavoritesScreen extends StatefulWidget {
  FavoritesScreen({
    super.key,
    required this.journeyId,
  }) : googleCalendarService = GoogleCalendarServiceFactory.create();

  final String journeyId;
  final GoogleCalendarService googleCalendarService;

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _databaseRef =
      FirebaseDatabase.instance.ref("favorite_places");
  List<Map<String, dynamic>> favorites = [];

  @override
  void initState() {
    super.initState();
    _fetchFavorites();
  }

  void _fetchFavorites() async {
    final user = _auth.currentUser;
    if (user != null) {
      final query =
          _databaseRef.orderByChild("journeyId").equalTo(widget.journeyId);
      query.once().then((DatabaseEvent event) {
        final data = event.snapshot.value as Map<dynamic, dynamic>?;

        if (data != null) {
          List<Map<String, dynamic>> loadedFavorites = [];
          data.forEach((key, value) {
            loadedFavorites.add({
              'placeName': value['placeName'],
              'placeLocation': value['placeLocation'],
              'wikiPlaceId': value['wikiPlaceId'],
              'placeId': value['placeId'],
              'fee': value['fee'],
              'website': value['website'],
              'phone': value['phone'],
              'opening_hours':
                  value['opening_hours'] ?? 'No opening hours info',
            });
          });

          setState(() {
            favorites = loadedFavorites;
          });
        } else {
          print("No favorites found.");
        }
      }).catchError((error) {
        print("Error fetching favorites: $error");
      });
    } else {
      print("User not logged in.");
    }
  }

  void _goToPlaceInfoPage(BuildContext context, Map<String, dynamic> place) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => PlaceInfoScreen(
          journeyId: widget.journeyId,
          placeName: place['placeName'],
          placeLocation: place['placeLocation'],
          fee: place['fee'],
          website: place['website'],
          phone: place['phone'],
          openingHours: place['opening_hours'],
          wikiPlaceId: place['wikiPlaceId'],
          placeId: place['placeId'],
          googleCalendarService: widget.googleCalendarService,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: favorites.isEmpty
          ? const Center(
              child: Text('No favorite places added yet.'),
            )
          : ListView.builder(
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final favorite = favorites[index];
                return InkWell(
                  onTap: () {
                    _goToPlaceInfoPage(context, favorite);
                  },
                  child: ListTile(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16.0),
                    leading: CircleAvatar(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      child: Icon(Icons.place, color: Colors.white),
                    ),
                    title: Text(
                      favorite['placeName'] ?? 'Unknown Place',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                    subtitle: Text(
                      favorite['placeLocation'] ?? 'Unknown Location',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey),
                  ),
                );
              },
            ),
    );
  }
}
