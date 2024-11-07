import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;

class CardsList extends StatelessWidget {
  const CardsList({
    super.key,
    required this.flag,
    required this.country,
    required this.city,
    required this.selectCity,
  });

  final String flag;
  final String country;
  final String city;
  final void Function() selectCity;

  Future<String> fetchSvg() async {
    try {
      final response = await http.get(Uri.parse(flag));
      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw Exception('Failed to load SVG');
      }
    } catch (e) {
      return 'Error loading SVG: $e';
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        selectCity();
      },
      child: Card(
        color: Color.fromARGB(255, 203, 220, 235),
        margin: const EdgeInsets.all(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 32,
                backgroundColor: Colors.black,
                child: ClipOval(
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: FutureBuilder<String>(
                      future: fetchSvg(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Image.asset(
                            'lib/assets/images/unknown_flag.png',
                            fit: BoxFit.cover,
                          );
                        } else if (snapshot.hasError) {
                          return Image.asset(
                            'lib/assets/images/unknown_flag.png',
                            fit: BoxFit.cover,
                          );
                        } else {
                          return SvgPicture.string(
                            snapshot.data!, // Виводимо SVG
                            fit: BoxFit.cover,
                          );
                        }
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      city,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(255, 0, 57, 115),
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      country,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
