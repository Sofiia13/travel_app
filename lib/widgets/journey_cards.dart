import 'package:flutter/material.dart';
import 'package:travel_app/screens/tabs.dart';

class JourneyCards extends StatelessWidget {
  const JourneyCards({
    super.key,
    required this.name,
    required this.journeyId,
  });

  final String name;
  final String journeyId;

  @override
  Widget build(BuildContext context) {
    void _goToHomePage(BuildContext context) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (ctx) => TabsScreen(
            journeyId: journeyId,
          ),
        ),
      );
    }

    return InkWell(
      onTap: () {
        _goToHomePage(context);
      },
      child: Card(
        color: Color.fromARGB(255, 221, 239, 255),
        elevation: 2,
        shadowColor: Colors.grey.withOpacity(0.2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 187, 230, 250), // Light blue
                Color.fromARGB(255, 123, 192, 248), // Slightly darker shade
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.travel_explore,
                      color: Colors.blue[700],
                    ),
                    SizedBox(width: 10),
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Text(
                  "Start your adventure!",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
