import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class AddPlaceToFavorites extends StatelessWidget {
  const AddPlaceToFavorites({
    super.key,
    required this.journeyId,
    required this.placeName,
    required this.placeLocation,
  });

  final String journeyId;
  final String placeName;
  final String placeLocation;

  @override
  Widget build(BuildContext context) {
    void addFavoritePlace(
      String journeyId,
      String placeName,
      String placeLocation,
    ) async {
      DatabaseReference ref =
          FirebaseDatabase.instance.ref("favorite_places").push();

      try {
        await ref.set({
          'journeyId': journeyId,
          'placeName': placeName,
          'plceLocation': placeLocation,
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Added to Favorites!'),
            duration: Duration(seconds: 3),
          ),
        );
      } catch (error) {
        print("Failed to add to favorites: $error");
      }
    }

    return OutlinedButton(
      onPressed: () {
        addFavoritePlace(journeyId, placeName, placeLocation);
      },
      style: OutlinedButton.styleFrom(
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(10),
      ),
      child: Icon(Icons.favorite),
    );
  }
}
