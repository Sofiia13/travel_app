import 'dart:convert';
import 'package:googleapis/androidpublisher/v3.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:travel_app/screens/city_info.dart';
import 'package:travel_app/widgets/cards.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({
    super.key,
    required this.journeyId,
  });

  final String journeyId;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final myController = TextEditingController();
  String enteredText = '';

  // final _allCities = [];
  // List<dynamic> _cities = [];
  List<Map<String, dynamic>> _allCountriesWithCities = [];
  List<Map<String, dynamic>> _searchedPlaces = [];

  void _getAllCities() async {
    final url = Uri.parse('https://countriesnow.space/api/v0.1/countries');
    final response = await http.get(url);

    // Fetch flags from the API
    final flagResponse = await http.get(
        Uri.parse('https://countriesnow.space/api/v0.1/countries/flag/images'));
    final Map<String, dynamic> flagData = json.decode(flagResponse.body);
    List<dynamic> flagCountries = flagData['data'];

    // Create a map for easy access to flags by country name
    Map<String, String> countryFlags = {};
    for (final country in flagCountries) {
      countryFlags[country['name']] = country['flag'];
      print('Country: ${country['name']}, Flag URL: ${country['flag']}');
    }

    if (response.statusCode == 200) {
      final Map<String, dynamic> listData = json.decode(response.body);
      final List<dynamic> countries = listData['data'];

      for (final country in countries) {
        String countryName = country['country'];
        List<String> cities = List<String>.from(country['cities']);

        // Add flag to the country data
        _allCountriesWithCities.add({
          'country': countryName,
          'cities': cities,
          'flag': countryFlags[countryName] ?? '',
        });
      }
    } else {
      print('Failed to load data');
    }
  }

  void _getSearchedPlaces() {
    _searchedPlaces = [];

    // Loop through all countries with cities
    for (final place in _allCountriesWithCities) {
      final countryMatch =
          place['country'].toLowerCase().contains(enteredText.toLowerCase());

      final matchingCities = (place['cities'] as List<String>)
          .where(
              (city) => city.toLowerCase().contains(enteredText.toLowerCase()))
          .toList();

      if (countryMatch) {
        for (final city in place['cities']) {
          _searchedPlaces.add({
            'country': place['country'],
            'city': city,
            'flag': place['flag'],
          });
        }
      }

      if (matchingCities.isNotEmpty && !countryMatch) {
        for (final city in matchingCities) {
          _searchedPlaces.add({
            'country': place['country'],
            'city': city,
            'flag': place['flag'],
          });
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    myController.addListener(() {
      setState(() {
        enteredText = myController.text;
        _getSearchedPlaces();
      });
    });
    _getAllCities();
  }

  void dispose() {
    myController.dispose();
    super.dispose();
  }

  void _selectCity(BuildContext context, String cityName) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => CityInfo(
          cityName: cityName,
          journeyId: widget.journeyId,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: TextField(
              controller: myController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(100),
                    ),
                  ),
                  hintText: 'Enter city or country you want to visit'),
            ),
          ),
          const SizedBox(height: 10),
          if (_searchedPlaces.isEmpty)
            Expanded(
              child: Center(
                child: Text(
                  '?',
                  style: TextStyle(fontSize: 150, color: Colors.grey),
                ),
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                itemCount: _searchedPlaces.length,
                itemBuilder: (context, index) {
                  final country = _searchedPlaces[index];
                  return CardsList(
                      flag:
                          country['flag'] != null && country['flag'].isNotEmpty
                              ? country['flag']
                              : 'unknown_flag.png',
                      country: country['country'],
                      city: country['city'],
                      selectCity: () {
                        _selectCity(context, country['city']);
                      });
                },
              ),
            ),
        ],
      ),
    );
  }
}
