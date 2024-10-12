import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:travel_app/screens/city_info.dart';
import 'package:travel_app/widgets/cards.dart';
import 'package:http/http.dart' as http;

class CitiesList extends StatefulWidget {
  const CitiesList({super.key});

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

    final Map<String, dynamic> listData = json.decode(response.body);
    _countries = listData['data'];

    for (final country in _countries) {
      for (final city in famousCities) {
        if (country['capital'] == city) {
          _filteredCapitals.add(country);
          break;
        }
      }
    }
    _filteredCapitals.toList();

    setState(() {
      _filteredCapitals;
    });
  }

  // void _getCapital() async {
  //   final url = 'https://api.dev.me/v1-list-countries';
  //   final response = await http.get(
  //     Uri.parse(url),
  //     headers: {
  //       'x-api-key':
  //           '6703dd5762923bee1de4b1ff-73961361aefd', // Replace with your actual API key
  //     },
  //   );
  //   final data = json.decode(response.body);
  //   print(data); // Do something with the data
  // }

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
  void initState() {
    super.initState();
    _getCapital();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Choose your city'),
      // ),
      body: ListView.builder(
          itemCount: _filteredCapitals.length,
          itemBuilder: (context, index) {
            final country = _filteredCapitals[index];
            return CardsList(
              country: country['name'],
              capital: country['capital'],
              selectCity: () {
                _selectCity(
                  context,
                  country['capital'],
                );
              },
            );
          }),
    );
  }
}
