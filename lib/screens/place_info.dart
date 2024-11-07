import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:travel_app/widgets/add_place_to_favorites.dart';
import 'package:travel_app/widgets/create_calendar_event_dialog.dart';
import 'package:travel_app/widgets/google_calendar_service_factory.dart';
import 'package:travel_app/widgets/place_photo.dart';
import 'package:travel_app/widgets/show_map.dart';
import 'package:geocoding/geocoding.dart';
import 'package:travel_app/widgets/text_with_place_info.dart';
import 'package:url_launcher/url_launcher.dart';

class PlaceInfoScreen extends StatefulWidget {
  const PlaceInfoScreen({
    super.key,
    required this.placeName,
    required this.placeLocation,
    required this.wikiPlaceId,
    required this.placeId,
    this.fee,
    this.phone,
    this.website,
    this.openingHours,
    required this.googleCalendarService,
    required this.journeyId,
  });

  final String placeName;
  final String placeLocation;
  final String wikiPlaceId;
  final String placeId;
  final String? fee;
  final String? phone;
  final String? website;
  final String? openingHours;
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
                          child: PlacePhoto(placeId: widget.wikiPlaceId),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 5,
                        ),
                        child: TextWithPlaceInfo(
                          placeId: widget.placeId,
                          wikiPlaceId: widget.wikiPlaceId,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 10,
                        ),
                        child: DefaultTextStyle(
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Location: ${widget.placeLocation}'),
                              SizedBox(height: 3),
                              if (widget.phone != null)
                                Text('Phone: ${widget.phone}'),
                              SizedBox(height: 3),
                              if (widget.website != null)
                                InkWell(
                                  child: Text.rich(
                                    TextSpan(
                                      children: [
                                        TextSpan(
                                          text: 'Website: ',
                                          style: TextStyle(color: Colors.black),
                                        ),
                                        TextSpan(
                                          text: widget.website,
                                          style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            decoration:
                                                TextDecoration.underline,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  onTap: () async {
                                    String website = widget.website!;
                                    if (!website.startsWith('http://') &&
                                        !website.startsWith('https://')) {
                                      website = 'https://$website';
                                    }
                                    final Uri websiteUri = Uri.parse(website);
                                    if (await canLaunchUrl(websiteUri)) {
                                      await launchUrl(websiteUri,
                                          mode: LaunchMode.externalApplication);
                                    } else {
                                      print("Could not launch $website");
                                    }
                                  },
                                ),
                            ],
                          ),
                        ),
                      ),
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
                              wikiPlaceId: widget.wikiPlaceId,
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
                    'Unable to retrieve coordinates for $widget.placeLocation',
                  ),
      ),
    );
  }
}
