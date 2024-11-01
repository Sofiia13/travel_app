import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:travel_app/widgets/places_listView.dart';

class CityInfo extends StatefulWidget {
  const CityInfo({
    super.key,
    required this.cityName,
    required this.journeyId,
  });

  final String cityName;
  final String journeyId;

  @override
  State<CityInfo> createState() => _CityInfoState();
}

class _CityInfoState extends State<CityInfo> {
  double? xCor;
  double? yCor;
  bool _isLoading = true;
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

  Future<void> _getCityCoordinates(String name) async {
    final url = Uri.parse(
        'http://api.openweathermap.org/geo/1.0/direct?q=$name&limit=1&appid=c84bc983237ae8f3e1cf6daa568aab15');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> listData = json.decode(response.body);
      if (listData.isNotEmpty) {
        setState(() {
          xCor = listData[0]['lon'];
          yCor = listData[0]['lat'];
          selectedCategory = categories[0];
          _isLoading = false;
        });
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      print('Failed to load city coordinates: ${response.statusCode}');
    }
  }

  @override
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
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(
                    //     vertical: 15,
                    //     horizontal: 20,
                    //   ),
                    //   child: MapWidget(xCor: xCor!, yCor: yCor!),
                    // ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Container(
                        margin: EdgeInsets.symmetric(
                          vertical: 6,
                          horizontal: 10,
                        ),
                        child: DropdownButtonFormField<String>(
                          value: selectedCategory,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(
                                color: const Color.fromARGB(255, 0, 57, 115),
                                width: 1,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(
                                  color: const Color.fromARGB(255, 0, 57, 115)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(
                                color: Colors.blue,
                                width: 2,
                              ),
                            ),
                            hintText: 'Select a category',
                            hintStyle: TextStyle(color: Colors.grey[400]),
                          ),
                          isExpanded: true,
                          items: categories.map((category) {
                            return DropdownMenuItem(
                              value: category,
                              child: Text(category),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedCategory = value!;
                            });
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: PlacesListview(
                        selectedCategory: selectedCategory,
                        xCor: xCor!,
                        yCor: yCor!,
                        journeyId: widget.journeyId,
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
