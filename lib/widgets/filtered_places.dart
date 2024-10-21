import 'package:flutter/material.dart';
import 'package:travel_app/screens/place_info.dart';

class FilteredPlaces extends StatelessWidget {
  const FilteredPlaces({
    super.key,
    required this.name,
  });

  final String name;

  void _selectPlace(BuildContext context, String placeName) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => PlaceInfoScreen(placeName: placeName),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        _selectPlace(
          context,
          name,
        );
      },
      child: Card(
        child: Column(children: [
          Text(name),
        ]),
      ),
    );
  }
}
