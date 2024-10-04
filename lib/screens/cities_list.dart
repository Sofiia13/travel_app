import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:travel_app/widgets/cards_list.dart';
import 'package:http/http.dart' as http;

class CitiesList extends StatefulWidget {
  const CitiesList({super.key});

  @override
  State<CitiesList> createState() => _CitiesListState();
}

class _CitiesListState extends State<CitiesList> {
  List<dynamic> _countries = [];
  List<String> famousCities = [
    'Istanbul',
    'London',
    'Paris',
    'Dubai',
    'Antalya',
    'Hong Kong',
    'BangKok',
    'New York',
    'Cancun',
    'Tokyo',
  ];

  void _getCapital() async {
    final url =
        Uri.parse('https://countriesnow.space/api/v0.1/countries/capital');
    final response = await http.get(url);

    final Map<String, dynamic> listData = json.decode(response.body);

    setState(() {
      _countries = listData['data'];
    });
  }

  @override
  void initState() {
    super.initState();
    _getCapital();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose your city'),
      ),
      body: ListView.builder(
          itemCount: _countries.length,
          itemBuilder: (context, index) {
            final country = _countries[index];
            return CardsList(
              country: country['name'],
              capital: country['capital'],
            );
          }),
    );
  }
}
