import 'package:flutter/material.dart';

class CardsList extends StatelessWidget {
  const CardsList({
    super.key,
    required this.country,
    required this.capital,
  });

  final String country;
  final String capital;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Text(capital),
                const SizedBox(height: 20),
                Text(country),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
