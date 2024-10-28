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
  GoogleCalendarService? _calendarService;
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
      setState(() {
        _calendarService = widget.googleCalendarService;
      });
    } else {
      print("Failed to authenticate");
    }
  }

  void _getCoordinatesFromAddress(String address) async {
    try {
      // Use the geocoding package to get coordinates from the address
      List<Location> locations = await locationFromAddress(address);
      if (locations.isNotEmpty) {
        setState(() {
          _coordinates =
              LatLng(locations.first.latitude, locations.first.longitude);
          _isLoading = false; // Update loading state
        });
      } else {
        print("No coordinates found for the address: $address");
        setState(() {
          _isLoading = false; // Update loading state
        });
      }
    } catch (e) {
      print("Error occurred while fetching coordinates: $e");
      setState(() {
        _isLoading = false; // Update loading state
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
            ? CircularProgressIndicator() // Show loading indicator while fetching coordinates
            : _coordinates != null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      PlacePhoto(placeId: widget.placeId),
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
                            AddPlaceToFavorites(
                              journeyId: widget.journeyId,
                              placeName: widget.placeName,
                              placeLocation: widget.placeLocation,
                              placeId: widget.placeId,
                            ),
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
                    'Unable to retrieve coordinates for $widget.placeLocation'), // Message when coordinates are not found
      ),
    );
  }
}
