import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
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
  List<Map<String, dynamic>> _allCountriesWithCities = [];
  List<Map<String, dynamic>> _searchedPlaces = [];

  void _getAllCities() async {
    final url = Uri.parse('https://countriesnow.space/api/v0.1/countries');
    final response = await http.get(url);

    final flagResponse = await http.get(
        Uri.parse('https://countriesnow.space/api/v0.1/countries/flag/images'));
    final Map<String, dynamic> flagData = json.decode(flagResponse.body);
    List<dynamic> flagCountries = flagData['data'];

    Map<String, String> countryFlags = {};
    for (final country in flagCountries) {
      countryFlags[country['name']] = country['flag'];
    }

    if (response.statusCode == 200) {
      final Map<String, dynamic> listData = json.decode(response.body);
      final List<dynamic> countries = listData['data'];

      for (final country in countries) {
        String countryName = country['country'];
        List<String> cities = List<String>.from(country['cities']);

        _allCountriesWithCities.add({
          'country': countryName,
          'cities': cities,
          'flag': countryFlags[countryName] ?? '',
        });
      }
    }
  }

  void _saveSearchedPlaces(List<Map<String, dynamic>> places) async {
    final prefs = await SharedPreferences.getInstance();
    String encodedData = json.encode(places);
    prefs.setString('searched_places_${widget.journeyId}', encodedData);
  }

  void _loadSearchedPlaces() async {
    final prefs = await SharedPreferences.getInstance();
    String? savedData = prefs.getString('searched_places_${widget.journeyId}');

    if (savedData != null) {
      List<dynamic> decodedData = json.decode(savedData);
      setState(() {
        _searchedPlaces = List<Map<String, dynamic>>.from(decodedData);
      });
    }
  }

  void _getSearchedPlaces() {
    _searchedPlaces = [];

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

    _saveSearchedPlaces(_searchedPlaces);
  }

  @override
  void initState() {
    super.initState();
    _loadSearchedPlaces();
    myController.addListener(() {
      setState(() {
        enteredText = myController.text;
        _getSearchedPlaces();
      });
    });
    _getAllCities();
  }

  @override
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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: TextField(
              controller: myController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(width: 2),
                ),
                hintText: 'City or country you want to visit',
                hintStyle: TextStyle(color: Colors.grey[600]),
              ),
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
                    flag: country['flag'] != null && country['flag'].isNotEmpty
                        ? country['flag']
                        : 'unknown_flag.png',
                    country: country['country'],
                    city: country['city'],
                    selectCity: () {
                      _selectCity(context, country['city']);
                    },
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
