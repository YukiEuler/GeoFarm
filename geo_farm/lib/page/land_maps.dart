import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class AppConstants {
  static const String mapBoxAccessToken = 'pk.eyJ1IjoieXVraXNha2kiLCJhIjoiY2xyOXo0ZXF0MDg3YjJpczRhd2kzMnhnZSJ9.tAgzPBtinffqMiw8BIkajA';

  static const String mapBoxStyleId = 'clr9z8rxg005p01qtbaoa8zvw';

  static final myLocation = LatLng(51.5090214, -0.1982948);
}

class LandMaps extends StatefulWidget {
  @override
  _LandMapsState createState() => _LandMapsState();
}

class _LandMapsState extends State<LandMaps> {
    @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 33, 32, 32),
        title: const Text('Flutter MapBox'),
      ),
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              minZoom: 5,
              maxZoom: 18,
              zoom: 13,
              center: AppConstants.myLocation,
            ),
            layers: [
              TileLayerOptions(
                urlTemplate:
                    "https://api.mapbox.com/styles/v1/yukisaki/clr9z8rxg005p01qtbaoa8zvw/wmts?access_token=pk.eyJ1IjoieXVraXNha2kiLCJhIjoiY2xyOXo0ZXF0MDg3YjJpczRhd2kzMnhnZSJ9.tAgzPBtinffqMiw8BIkajA",
                additionalOptions: {
                  'mapStyleId': AppConstants.mapBoxStyleId,
                  'accessToken': AppConstants.mapBoxAccessToken,
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

}