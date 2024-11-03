import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class AddPlaceToFavorites extends StatefulWidget {
  const AddPlaceToFavorites({
    super.key,
    required this.journeyId,
    required this.placeName,
    required this.placeLocation,
    required this.placeId,
  });

  final String journeyId;
  final String placeName;
  final String placeLocation;
  final String placeId;

  @override
  State<AddPlaceToFavorites> createState() => _AddPlaceToFavoritesState();
}

class _AddPlaceToFavoritesState extends State<AddPlaceToFavorites> {
  bool isFavorite = false;
  String? favoriteKey;

  @override
  void initState() {
    super.initState();
    _checkIfFavorite();
  }

  void _checkIfFavorite() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("favorite_places");

    final snapshot =
        await ref.orderByChild("journeyId").equalTo(widget.journeyId).get();

    if (snapshot.exists) {
      for (var child in snapshot.children) {
        final data = child.value as Map<dynamic, dynamic>;
        if (data['placeName'] == widget.placeName) {
          setState(() {
            isFavorite = true;
            favoriteKey = child.key;
          });
          return;
        }
      }
    }

    setState(() {
      isFavorite = false;
    });
  }

  void _toggleFavorite() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("favorite_places");

    if (isFavorite && favoriteKey != null) {
      await ref.child(favoriteKey!).remove();
      setState(() {
        isFavorite = false;
        favoriteKey = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Removed from Favorites!'),
          duration: Duration(seconds: 3),
        ),
      );
    } else {
      DatabaseReference newRef = ref.push();
      await newRef.set({
        'journeyId': widget.journeyId,
        'placeName': widget.placeName,
        'placeLocation': widget.placeLocation,
        'placeId': widget.placeId,
      });
      setState(() {
        isFavorite = true;
        favoriteKey = newRef.key;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Added to Favorites!'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () {
        _toggleFavorite();
      },
      style: OutlinedButton.styleFrom(
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(10),
      ),
      child: Icon(
        isFavorite ? Icons.favorite : Icons.favorite_border,
        color: isFavorite ? Colors.red : Theme.of(context).colorScheme.primary,
      ),
    );
  }
}
