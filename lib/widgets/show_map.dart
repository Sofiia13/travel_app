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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(35),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 20,
              horizontal: 20,
            ),
            child: Container(
              width: screenSize.width * 0.8,
              height: screenSize.height * 0.8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: MapWidget(xCor: widget.xCor, yCor: widget.yCor),
              ),
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
      ),
    );
  }
}
