import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final myController = TextEditingController();
  String enteredText = '';

  final _allCities = [];
  List<dynamic> _cities = [];

  void _getAllCities() async {
    final url = Uri.parse('https://countriesnow.space/api/v0.1/countries');
    final response = await http.get(url);
    final Map<String, dynamic> listData = json.decode(response.body);
    _cities = listData['data'];

    for (final city in _cities) {
      _allCities.add(city['country']);
    }
    _allCities.toList();
    print(_allCities);
  }

  @override
  void initState() {
    super.initState();
    myController.addListener(() {
      setState(() {
        enteredText = myController.text;
      });
    });
    _getAllCities();
  }

  void dispose() {
    myController.dispose();
    super.dispose();
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
        Text(enteredText),
      ],
    ));
  }
}
