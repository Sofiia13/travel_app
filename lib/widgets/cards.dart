import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
          padding: const EdgeInsets.all(30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            // crossAxisAlignment: CrossAxisAlignment.start,
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
                    child: flag.endsWith('.svg')
                        ? SvgPicture.network(
                            flag,
                            placeholderBuilder: (context) => Image.asset(
                              'lib/assets/images/unknown_flag.png',
                              fit: BoxFit.cover,
                            ),
                            fit: BoxFit.cover,
                          )
                        : Image.network(
                            flag,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                'lib/assets/images/unknown_flag.png',
                                fit: BoxFit.cover,
                              );
                            },
                          ),
                  ),
                ),
              ),
              const SizedBox(width: 30),
              Column(
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
                  ),
                  const SizedBox(height: 20),
                  Text(
                    country,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
