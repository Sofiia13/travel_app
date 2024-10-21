import 'package:flutter/material.dart';

class PlaceInfoScreen extends StatelessWidget {
  const PlaceInfoScreen({super.key, required this.placeName});

  final String placeName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(placeName),
      ),
      body: Center(
          child: Column(
        children: [
          Text('Some place info'),
          Text('Bla bla bla'),
          OutlinedButton(
              onPressed: () {}, child: Text('Add to google calendar'))
        ],
      )),
    );
  }
}
