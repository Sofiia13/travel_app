import 'package:flutter/material.dart';
import 'package:travel_app/screens/place_info.dart';
import 'package:travel_app/widgets/google_calendar_service_factory.dart';

class FilteredPlaces extends StatelessWidget {
  FilteredPlaces({
    super.key,
    required this.name,
    required this.location,
  }) : googleCalendarService = GoogleCalendarServiceFactory.create();

  final String name;
  final String location;
  final GoogleCalendarService googleCalendarService;

  void _selectPlace(BuildContext context, String placeName) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => PlaceInfoScreen(
          placeName: placeName,
          location: location,
          googleCalendarService: googleCalendarService,
        ),
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
