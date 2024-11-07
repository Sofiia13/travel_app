import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapWidget extends StatelessWidget {
  const MapWidget({super.key, required this.xCor, required this.yCor});

  final double xCor;
  final double yCor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 2.5,
      child: FlutterMap(
        options: MapOptions(
          initialCenter: LatLng(yCor, xCor),
          initialZoom: 10.0,
        ),
        children: [
          TileLayer(
            urlTemplate:
                "https://maps.geoapify.com/v1/tile/osm-bright/{z}/{x}/{y}.png?&apiKey=731dfd7dfb0d4ebb99295e0cfe811177",
            userAgentPackageName: 'com.example.travel_app',
          ),
          MarkerLayer(
            markers: [
              Marker(
                width: 60.0,
                height: 60.0,
                point: LatLng(yCor, xCor),
                child: Icon(
                  Icons.location_pin,
                  size: 40.0,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
