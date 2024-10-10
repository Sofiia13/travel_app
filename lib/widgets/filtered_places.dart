import 'package:flutter/material.dart';

class FilteredPlaces extends StatelessWidget {
  const FilteredPlaces({
    super.key,
    required this.name,
  });

  final String name;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Card(
        child: Column(children: [
          Text(name),
        ]),
      ),
    );
  }
}
