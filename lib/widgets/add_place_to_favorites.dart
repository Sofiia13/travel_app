import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class AddPlaceToFavorites extends StatelessWidget {
  const AddPlaceToFavorites({super.key});

  @override
  Widget build(BuildContext context) {
    void addFavoritePlace(String journeyId, String placeName) async {
      DatabaseReference ref =
          FirebaseDatabase.instance.ref("favorite_places").push();

      await ref.set({
        'journeyId': journeyId,
        'placeName': placeName,
      });
    }

    return OutlinedButton(
      onPressed: () {},
      style: OutlinedButton.styleFrom(
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(10),
      ),
      child: Icon(Icons.favorite),
    );
  }
}
