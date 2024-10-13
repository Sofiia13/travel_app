import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:travel_app/screens/city_info.dart';
import 'package:travel_app/widgets/cards.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

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

    if (response.statusCode == 200) {
      final Map<String, dynamic> listData = json.decode(response.body);
      final List<dynamic> countries = listData['data'];

      for (final country in countries) {
        String countryName = country['country'];
        List<String> cities = List<String>.from(country['cities']);

        _allCountriesWithCities.add({
          'country': countryName,
          'cities': cities,
        });
      }
      // for (var countryWithCities in _allCountriesWithCities) {
      //   print(
      //       "Country: ${countryWithCities['country']}, Cities: ${countryWithCities['cities']}");
      // }
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

      // If the country name matches, add all its cities to the result
      if (countryMatch) {
        for (final city in place['cities']) {
          _searchedPlaces.add({
            'country': place['country'],
            'city': city, // Add each city individually
          });
        }
      }

      // If cities match (but country doesn't), add only the matching cities
      if (matchingCities.isNotEmpty && !countryMatch) {
        for (final city in matchingCities) {
          _searchedPlaces.add({
            'country': place['country'],
            'city': city, // Add each matching city
          });
        }
      }
    }

    // Debugging: Print the result to verify
    print(_searchedPlaces);
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
                  hintText: 'Enter city you want to visit'),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: _searchedPlaces.length,
              itemBuilder: (context, index) {
                final country = _searchedPlaces[index];
                return CardsList(
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
