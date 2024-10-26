import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
// import 'package:googleapis/servicemanagement/v1.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({
    super.key,
    required this.journeyId,
  });

  final String journeyId;

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
                return ListTile(
                  title: Text(favorite['placeName'] ?? 'Unknown Place'),
                  subtitle:
                      Text(favorite['placeLocation'] ?? 'Unknown Location'),
                );
              },
            ),
    );
  }
}
