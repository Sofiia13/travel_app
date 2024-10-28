import 'package:flutter/material.dart';
import 'package:travel_app/widgets/map.dart';

class ShowMap extends StatefulWidget {
  const ShowMap({
    super.key,
    required this.xCor,
    required this.yCor,
  });

  final double xCor;
  final double yCor;

  @override
  State<ShowMap> createState() => _ShowMapState();
}

class _ShowMapState extends State<ShowMap> {
  void _showMapDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final screenSize = MediaQuery.of(context).size;
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 20,
              horizontal: 20,
            ),
            child: Container(
              width: screenSize.width * 0.8,
              height: screenSize.height * 0.8,
              // padding: const EdgeInsets.symmetric(
              //   vertical: 15,
              //   horizontal: 10,
              // ),
              child: MapWidget(
                  xCor: widget.xCor, yCor: widget.yCor), // Your map widget
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () {
        _showMapDialog(context);
      },
      style: OutlinedButton.styleFrom(
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(10),
      ),
      child: Icon(
        Icons.map_outlined,
        // color: isFavorite ? Colors.red : Colors.grey,
        // color: Colors.grey,
      ),
    );
  }
}
