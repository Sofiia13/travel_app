import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:travel_app/widgets/map.dart';

class CityInfo extends StatefulWidget {
  CityInfo({super.key, required this.cityName});

  final String cityName;

  @override
  State<CityInfo> createState() => _CityInfoState();
}

class _CityInfoState extends State<CityInfo> {
  @override
  List<dynamic> _cityCoordinates = [];

  double? xCor; // Store longitude
  double? yCor; // Store latitude

  void _getCityCoordinates(String name) async {
    final url = Uri.parse('https://api.api-ninjas.com/v1/city?name=$name');
    final response = await http.get(url, headers: {
      'X-Api-Key':
          'w1alNvn/gAEdtCWgy1cKgg==8aACMMX2MSFRlCmI', // Make sure to add your API key here
    });

    if (response.statusCode == 200) {
      final List<dynamic> listData = json.decode(response.body);

      setState(() {
        _cityCoordinates = listData; // Store the entire response
        if (_cityCoordinates.isNotEmpty) {
          xCor = _cityCoordinates[0]['longitude'];
          yCor = _cityCoordinates[0]['latitude'];
        } else {
          // Handle the case where no data is returned
          xCor = null;
          yCor = null;
        }
      });

      print('Coordinates: $xCor, $yCor');
    } else {
      print('Failed to load city coordinates: ${response.statusCode}');
      // Handle the error here, maybe set xCor and yCor to null
      setState(() {
        xCor = null;
        yCor = null;
      });
    }
  }

  void initState() {
    super.initState();
    _getCityCoordinates(widget.cityName);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.cityName),
      ),
      body: (xCor != null && yCor != null)
          ? MapWidget(xCor: xCor!, yCor: yCor!) // Use null assertion operator
          : Center(
              child: xCor == null && yCor == null
                  ? CircularProgressIndicator() // Loading indicator
                  : Text(
                      'Coordinates not found. Please try again.'), // Fallback message
            ),
    );
  }
}
