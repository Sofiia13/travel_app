import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:travel_app/widgets/add_place_to_favorites.dart';
import 'package:travel_app/widgets/create_calendar_event_dialog.dart';
import 'package:travel_app/widgets/google_calendar_service_factory.dart';
import 'package:travel_app/widgets/place_photo.dart';
import 'package:travel_app/widgets/show_map.dart';
import 'package:geocoding/geocoding.dart';

class PlaceInfoScreen extends StatefulWidget {
  const PlaceInfoScreen({
    super.key,
    required this.placeName,
    required this.placeLocation,
    required this.placeId,
    required this.googleCalendarService,
    required this.journeyId,
  });

  final String placeName;
  final String placeLocation;
  final String placeId;
  final GoogleCalendarService googleCalendarService;
  final String journeyId;

  @override
  State<PlaceInfoScreen> createState() => _PlaceInfoScreenState();
}

class _PlaceInfoScreenState extends State<PlaceInfoScreen> {
  LatLng? _coordinates;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeCalendarService();
    _getCoordinatesFromAddress(widget.placeLocation);
  }

  void _initializeCalendarService() async {
    final calendarApi =
        await widget.googleCalendarService.signInAndGetCalendarApi();

    if (calendarApi != null) {
      // Successfully authenticated
      print("Successfully authenticated and obtained Calendar API");
      setState(() {});
    } else {
      print("Failed to authenticate");
    }
  }

  void _getCoordinatesFromAddress(String address) async {
    try {
      List<Location> locations = await locationFromAddress(address);
      if (locations.isNotEmpty) {
        setState(() {
          _coordinates =
              LatLng(locations.first.latitude, locations.first.longitude);
          _isLoading = false;
        });
      } else {
        print("No coordinates found for the address: $address");
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print("Error occurred while fetching coordinates: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.placeName),
      ),
      body: Center(
        child: _isLoading
            ? CircularProgressIndicator()
            : _coordinates != null
                ? ListView(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 300,
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        clipBehavior: Clip.hardEdge,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: PlacePhoto(placeId: widget.placeId),
                        ),
                      ),
                      Text('Some place info'),
                      Text('Bla bla bla'),
                      Padding(
                        padding: const EdgeInsets.all(15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ShowMap(
                              xCor: _coordinates!.longitude,
                              yCor: _coordinates!.latitude,
                            ),
                            // SizedBox(width: 5),
                            AddPlaceToFavorites(
                              journeyId: widget.journeyId,
                              placeName: widget.placeName,
                              placeLocation: widget.placeLocation,
                              placeId: widget.placeId,
                            ),
                            // SizedBox(width: 5),
                            CreateEventDialog(
                              name: widget.placeName,
                              location: widget.placeLocation,
                              googleCalendarService:
                                  widget.googleCalendarService,
                              journeyId: widget.journeyId,
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                : Text(
                    'Unable to retrieve coordinates for $widget.placeLocation'),
      ),
    );
  }
}
