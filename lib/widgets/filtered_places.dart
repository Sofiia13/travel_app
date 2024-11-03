import 'package:flutter/material.dart';
import 'package:travel_app/screens/place_info.dart';
import 'package:travel_app/widgets/google_calendar_service_factory.dart';

class FilteredPlaces extends StatelessWidget {
  FilteredPlaces({
    super.key,
    required this.placeData,
  }) : googleCalendarService = GoogleCalendarServiceFactory.create();

  final Map<String, dynamic> placeData;
  final GoogleCalendarService googleCalendarService;

  void _selectPlace(BuildContext context, String placeName) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => PlaceInfoScreen(
          placeName: placeName,
          placeLocation: placeData['location'],
          fee: placeData['fee'],
          website: placeData['website'],
          phone: placeData['phone'],
          openingHours: placeData['opening_hours'],
          wikiPlaceId: placeData['wikiPlaceId'],
          placeId: placeData['placeId'],
          journeyId: placeData['journeyId'],
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
          placeData['name'],
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 2.5,
        ),
        child: Card(
          color: Color.fromARGB(255, 203, 220, 235),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  placeData['name'],
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 0, 57, 115),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  placeData['location'],
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
