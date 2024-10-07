import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapWidget extends StatelessWidget {
  MapWidget({super.key, required this.xCor, required this.yCor});

  double xCor;
  double yCor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      // width: double.infinity,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 2,
      child: FlutterMap(
        options: MapOptions(
          center: LatLng(yCor, xCor), // Coordinates for London
          zoom: 10.0,
        ),
        children: [
          TileLayer(
            urlTemplate:
                "https://maps.geoapify.com/v1/tile/osm-bright/{z}/{x}/{y}.png?&apiKey=731dfd7dfb0d4ebb99295e0cfe811177",
            userAgentPackageName: 'com.example.travel_app',
            // subdomains: ['a', 'b', 'c'],
          ),
        ],
      ),
    );
  }
}
