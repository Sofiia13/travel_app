import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:travel_app/widgets/map.dart';

class CityInfo extends StatefulWidget {
  const CityInfo({super.key, required this.cityName});

  final String cityName;

  @override
  State<CityInfo> createState() => _CityInfoState();
}

class _CityInfoState extends State<CityInfo> {
  @override
  List<dynamic> _cityCoordinates = [];

  String? _selectedCategory;

  List<String> categories = [
    'activity',
    'commercial',
    'catering',
    'entertainment',
    'healthcare',
    'natural',
    'tourism',
    'religion',
  ];

  double? xCor;
  double? yCor;

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
        } else {
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
    _selectedCategory = categories[0];
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.cityName),
      ),
      body: (xCor != null && yCor != null)
          ? Column(
              children: [
                Expanded(
                  child: MapWidget(xCor: xCor!, yCor: yCor!),
                ),
                Expanded(
                  child: DropdownButton(
                    value: _selectedCategory,
                    items: [
                      for (final category in categories)
                        DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedCategory = value!;
                      });
                    },
                  ),
                ),
                // Expanded(
                //   child: ListView.builder(
                //     itemCount: categories.length,
                //     itemBuilder: (context, index) {
                //       return ;
                //     },
                //   ),
                // ),
              ],
            )
          : Center(
              child: xCor == null && yCor == null
                  ? const CircularProgressIndicator()
                  : const Text('Coordinates not found. Please try again.'),
            ),
    );
  }
}
