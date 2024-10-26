import 'package:flutter/material.dart';
import 'package:travel_app/screens/place_info.dart';
import 'package:travel_app/widgets/google_calendar_service_factory.dart';

class FilteredPlaces extends StatelessWidget {
  FilteredPlaces({
    super.key,
    required this.name,
    required this.location,
    required this.placeId,
    required this.journeyId,
  }) : googleCalendarService = GoogleCalendarServiceFactory.create();

  final String name;
  final String location;
  final String placeId;
  final GoogleCalendarService googleCalendarService;
  final String journeyId;

  void _selectPlace(BuildContext context, String placeName) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => PlaceInfoScreen(
          placeName: placeName,
          placeLocation: location,
          placeId: placeId,
          journeyId: journeyId,
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
