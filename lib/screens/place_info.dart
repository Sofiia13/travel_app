import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:travel_app/widgets/add_place_to_favorites.dart';
import 'package:travel_app/widgets/create_calendar_event_dialog.dart';
import 'package:travel_app/widgets/google_calendar_service_factory.dart';
import 'package:travel_app/widgets/place_photo.dart';
import 'package:travel_app/widgets/show_map.dart';
import 'package:geocoding/geocoding.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

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
  String description = '';

  @override
  void initState() {
    super.initState();
    _initializeCalendarService();
    _getCoordinatesFromAddress(widget.placeLocation);
    _getPlaceInfoFromWiki(widget.placeId);
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

  String capitalizeFirstLetter(String text) {
    if (text.isEmpty) {
      return text;
    }
    return text[0].toUpperCase() + text.substring(1);
  }

  Future<void> _getPlaceInfoFromWiki(String id) async {
    final url = Uri.parse(
        'https://www.wikidata.org/w/rest.php/wikibase/v0/entities/items/$id');
    final headers = {
      'Accept': 'application/json',
      'Authorization':
          'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiJmYmI1ZDk1ZTJiYTg3NDBmYmYwOWZiMTlkZWRjYjkwNyIsImp0aSI6IjE3OGZjYjUwYWFlNjc5NWI2OWE5ODQzOTBmZmVmZTg1NTQzZDc5OGM2ZDkxZmVjZTg1OGFlMzMzMjQ1ODYyZWYyYTMwZDRlNDQwMGMzMWMzIiwiaWF0IjoxNzI5NjA1NjExLjM5MTY3LCJuYmYiOjE3Mjk2MDU2MTEuMzkxNjc2LCJleHAiOjMzMjg2NTE0NDExLjM4NDQzNCwic3ViIjoiNzY3NzUzMDAiLCJpc3MiOiJodHRwczovL21ldGEud2lraW1lZGlhLm9yZyIsInJhdGVsaW1pdCI6eyJyZXF1ZXN0c19wZXJfdW5pdCI6NTAwMCwidW5pdCI6IkhPVVIifSwic2NvcGVzIjpbImJhc2ljIiwiaGlnaHZvbHVtZSIsInZpZXdteXdhdGNobGlzdCIsImVkaXRteXdhdGNobGlzdCIsImNoZWNrdXNlci10ZW1wb3JhcnktYWNjb3VudCJdfQ.lAZZ_mYuU2UqIc4ZyU6iZ6-coT1U6ltziDJk_9znO0DHG5EMrbYlrtlKPhM7Ft0KL7fnu-qJ3Hkuw3YIjgG_VEbmUJtIr350w8Qp0zIpc4Gx2FB6od18UMnHZE21fHBQDWnCR0EHXnj31HPDLM0CTGYhAP77fOOpE2ADJHpVEQU3FqjTTTE37sev-_BoslGg_fCDARc1Vsq9rZ7rjNGP3liGsTjzT4LZE2BiZWaTY_qHuHybomNncnpYe0VFhsSHu8QfjkF89TweEszBGrDKNS3uHXc6T8MBZa3RTCrCmWGe2U6fd9pv3jWacxbc-nfCgEo-R4Ud96mNygSAoL7yKy61KJMLSfR_QwMOa9r0MZDSqy_3UuOE8EuvwddFzRma3esAni6f8h25GLPv6_pyh3NsF8u59nC2AI3jOIdP2US_kvz8L80YlUSvGSedJk5wbXAFwd5ZlJA9Lv7Jlh67oA-0tEA7cuivtSsG9Kjyv9ifE1v-0ik8j80cqSBkspYVUnlMP9Fk9BnFyHyIymEko6c-COjD1icy7ci8DXWmRboS63MYZpyymI2ux804NakH3Jy3_hPagAVm99aZd4Ykis8POk3EQI-LfiYKF7Pw5GJpeTdI_P8YtaoJvBSzvm0VPxJOmH_QcCz51B4xV7ZzJp3mJN-F4FIzsL7dkRfkqD8', // Customize this as necessary
    };

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = json.decode(response.body);

      if (jsonData.containsKey('descriptions') &&
          jsonData['descriptions'] is Map) {
        final Map<String, dynamic> descriptions = jsonData['descriptions'];

        if (descriptions.containsKey('en')) {
          setState(() {
            description = capitalizeFirstLetter(descriptions['en']);
            _isLoading = false;
          });
        } else if (descriptions.containsKey('fr')) {
          setState(() {
            description = capitalizeFirstLetter(descriptions['fr']);
            _isLoading = false;
          });
        } else {
          print('No English description found for the given place.');
          setState(() {
            description = 'Description not available.';
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          _isLoading = false;
        });
      }
      print('Failed to load place description: ${response.statusCode}');
    } else {
      print('Can not connect to WikiAPI');
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
                      description.isNotEmpty
                          ? Text(
                              description,
                              style: TextStyle(fontSize: 16),
                            )
                          : Container(),
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
