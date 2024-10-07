import 'package:flutter/material.dart';
import 'package:travel_app/widgets/map.dart';

class CityInfo extends StatelessWidget {
  const CityInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About City'),
      ),
      body: MapWidget(),
    );
  }
}
