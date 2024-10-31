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
    print('Flag URL: $flag');
    return InkWell(
      onTap: () {
        selectCity();
      },
      child: Card(
        margin: const EdgeInsets.all(10),
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 25,
                backgroundColor: Colors.grey,
                child: ClipOval(
                  child: flag.endsWith('.svg')
                      ? SvgPicture.network(
                          flag,
                          placeholderBuilder: (context) => Image.asset(
                            'lib/assets/images/unknown_flag.png',
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          // You can also use a placeholder for error handling
                        )
                      : Image.network(
                          flag,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              'lib/assets/images/unknown_flag.png',
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            );
                          },
                        ),
                ),
              ),
              const SizedBox(width: 20),
              Column(
                children: [
                  Text(city),
                  const SizedBox(height: 20),
                  Text(country),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
