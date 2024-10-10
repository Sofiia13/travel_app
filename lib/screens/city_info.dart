import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:travel_app/widgets/filtered_places.dart';
import 'package:travel_app/widgets/map.dart';

class CityInfo extends StatefulWidget {
  const CityInfo({super.key, required this.cityName});

  final String cityName;

  @override
  State<CityInfo> createState() => _CityInfoState();
}

class _CityInfoState extends State<CityInfo> {
  List<dynamic> _cityCoordinates = [];
  List<dynamic> _places = [];
  List<dynamic> _placeName = [];

  int limit = 10;
  double? xCor;
  double? yCor;
  bool _isLoading = true;

  final String apiKey = '731dfd7dfb0d4ebb99295e0cfe811177';
  String? selectedCategory;

  List<String> categories = [
    'activity',
    'commercial',
    'catering',
    'entertainment',
    'healthcare',
    'natural',
    'tourism',
    'religion',
    'sport',
  ];

  @override
  void initState() {
    super.initState();
    _getCityCoordinates(widget.cityName);
  }

  void _getCityCoordinates(String name) async {
    final url = Uri.parse('https://api.api-ninjas.com/v1/city?name=$name');
    final response = await http.get(url, headers: {
      'X-Api-Key': 'w1alNvn/gAEdtCWgy1cKgg==8aACMMX2MSFRlCmI',
    });

    if (response.statusCode == 200) {
      final List<dynamic> listData = json.decode(response.body);

      setState(() {
        _cityCoordinates = listData;
        if (_cityCoordinates.isNotEmpty) {
          xCor = _cityCoordinates[0]['longitude'];
          yCor = _cityCoordinates[0]['latitude'];
          selectedCategory = categories[0];
          getPlacesByCategory(selectedCategory, xCor, yCor, 10);
        } else {
          xCor = null;
          yCor = null;
        }
      });
    } else {
      setState(() {
        xCor = null;
        yCor = null;
        _isLoading = false;
      });
      print('Failed to load city coordinates: ${response.statusCode}');
    }
  }

  void getPlacesByCategory(selectedCategory, xCor, yCor, limit) async {
    final url = Uri.parse(
        'https://api.geoapify.com/v2/places?categories=$selectedCategory&filter=circle:${xCor},${yCor},2000&&limit=10&apiKey=$apiKey');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> listData = json.decode(response.body);
      setState(() {
        _places = listData['features'];

        _placeName =
            _places.map((place) => place['properties']['name']).toList();
        _isLoading = false;
      });
    } else {
      print('Failed to load places: ${response.statusCode}');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.cityName),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : (xCor != null && yCor != null)
              ? Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 20),
                      child: MapWidget(xCor: xCor!, yCor: yCor!),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: DropdownButton<String>(
                        value: selectedCategory,
                        items: categories
                            .map((category) => DropdownMenuItem(
                                  value: category,
                                  child: Text(category),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedCategory = value!;
                            _isLoading = true;
                            getPlacesByCategory(
                                selectedCategory, xCor, yCor, 10);
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: _placeName.length,
                        itemBuilder: (context, index) {
                          return FilteredPlaces(
                            name: _placeName[index],
                          );
                        },
                      ),
                    ),
                  ],
                )
              : const Center(
                  child: Text('Coordinates not found. Please try again.'),
                ),
    );
  }
}
