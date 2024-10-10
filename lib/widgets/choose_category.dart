import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:travel_app/widgets/filtered_places.dart';

class ChooseCategory extends StatefulWidget {
  const ChooseCategory({
    super.key,
    required this.xCor,
    required this.yCor,
  });

  final double xCor;
  final double yCor;

  @override
  State<ChooseCategory> createState() => _ChooseCategoryState();
}

class _ChooseCategoryState extends State<ChooseCategory> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Expanded(
        //   child: ListView.builder(
        //     itemCount: _placeName.length,
        //     itemBuilder: (context, index) {
        //       return FilteredPlaces(
        //         name: _placeName[index],
        //       );
        //     },
        //   ),
        // ),
      ],
    );
  }
}
