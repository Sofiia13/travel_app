import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:travel_app/widgets/filtered_places.dart';

class PlacesListview extends StatefulWidget {
  const PlacesListview({
    super.key,
    required this.selectedCategory,
    required this.xCor,
    required this.yCor,
    required this.journeyId,
  });

  final String? selectedCategory;
  final double xCor;
  final double yCor;
  final String journeyId;

  @override
  State<PlacesListview> createState() => _PlacesListviewState();
}

class _PlacesListviewState extends State<PlacesListview> {
  List<dynamic> _places = [];
  bool _isLoading = true;

  final String apiKey = '731dfd7dfb0d4ebb99295e0cfe811177';

  @override
  void initState() {
    super.initState();
    if (widget.selectedCategory != null) {
      getPlacesByCategory(
          widget.selectedCategory!, widget.xCor, widget.yCor, 10);
    }
  }

  @override
  void didUpdateWidget(covariant PlacesListview oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedCategory != widget.selectedCategory) {
      getPlacesByCategory(
          widget.selectedCategory!, widget.xCor, widget.yCor, 10);
    }
  }

  void getPlacesByCategory(
      String selectedCategory, double xCor, double yCor, int limit) async {
    final url = Uri.parse(
        'https://api.geoapify.com/v2/places?categories=$selectedCategory&filter=circle:$xCor,$yCor,2000&limit=$limit&apiKey=$apiKey');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> listData = json.decode(response.body);
      setState(() {
        _places = listData['features'];
        _isLoading = false;
      });
    } else {
      print('Failed to load places: ${response.statusCode}');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView.builder(
      itemCount: _places.length,
      itemBuilder: (context, index) {
        final place = _places[index]['properties'];
        final placeData = {
          'name': place['address_line1'] ?? 'Unknown',
          'location': place['address_line2'] ?? 'Unknown',
          'wikiPlaceId': place['datasource']['raw']['wikidata'] ?? '',
          'placeId': place['place_id'] ?? '',
          'fee': place['datasource']['raw']['fee'] ?? 'Not Available',
          'phone': place['contact']?['phone'] ?? 'Not Available',
          'website': place['website'] ?? 'Not Available',
          'openingHours':
              place['datasource']['raw']['opening_hours'] ?? 'Not Available',
          'journeyId': widget.journeyId,
        };

        return FilteredPlaces(
          placeData: placeData,
        );
      },
    );
  }
}
