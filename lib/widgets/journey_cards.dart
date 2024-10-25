import 'package:flutter/material.dart';
import 'package:travel_app/screens/tabs.dart';

class JourneyCards extends StatelessWidget {
  const JourneyCards({super.key, required this.name, required this.journeyId});

  final String name;
  final String journeyId;

  @override
  Widget build(BuildContext context) {
    void _goToHomePage(BuildContext context) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (ctx) => const TabsScreen(),
        ),
      );
    }

    return InkWell(
      onTap: () {
        _goToHomePage(context);
      },
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(name),
            ],
          ),
        ),
      ),
    );
  }
}
