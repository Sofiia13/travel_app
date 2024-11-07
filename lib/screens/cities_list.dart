import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:travel_app/screens/city_info.dart';
import 'package:travel_app/widgets/cards.dart';
import 'package:http/http.dart' as http;

class CitiesList extends StatefulWidget {
  const CitiesList({
    super.key,
    required this.journeyId,
  });

  final String journeyId;

  @override
  State<CitiesList> createState() => _CitiesListState();
}

class _CitiesListState extends State<CitiesList> {
  List<dynamic> _countries = [];

  List<String> famousCities = [
    'Paris',
    'Hong Kong',
    'Bangkok',
    'Tokyo',
    'London',
  ];
  final _filteredCapitals = [];

  void _getCapital() async {
    final url =
        Uri.parse('https://countriesnow.space/api/v0.1/countries/capital');
    final response = await http.get(url);

    final flagResponse = await http.get(
        Uri.parse('https://countriesnow.space/api/v0.1/countries/flag/images'));
    final Map<String, dynamic> flagData = json.decode(flagResponse.body);
    List<dynamic> flagCountries = flagData['data'];

    Map<String, String> countryFlags = {};
    for (final country in flagCountries) {
      countryFlags[country['name']] = country['flag'];
    }

    final Map<String, dynamic> listData = json.decode(response.body);
    _countries = listData['data'];

    for (final country in _countries) {
      for (final city in famousCities) {
        if (country['capital'] == city) {
          _filteredCapitals.add({
            'name': country['name'],
            'capital': country['capital'],
            'flag': countryFlags[country['name']] ?? '',
          });
          break;
        }
      }
    }
    if (mounted) {
      setState(() {
        _filteredCapitals;
      });
    }
  }

  void _selectCity(BuildContext context, String cityName, String journeyId) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => CityInfo(
          cityName: cityName,
          journeyId: journeyId,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _getCapital();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
          itemCount: _filteredCapitals.length,
          itemBuilder: (context, index) {
            final country = _filteredCapitals[index];
            return CardsList(
              flag: country['flag'] != null && country['flag'].isNotEmpty
                  ? country['flag']
                  : 'unknown_flag.png',
              country: country['name'],
              city: country['capital'],
              selectCity: () {
                _selectCity(
                  context,
                  country['capital'],
                  widget.journeyId,
                );
              },
            );
          }),
    );
  }
}
