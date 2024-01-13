import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LandMapsPage extends StatefulWidget {
  const LandMapsPage({Key? key}) : super(key: key);

  @override
  State<LandMapsPage> createState() => _LandMapsPageState();
}

class _LandMapsPageState extends State<LandMapsPage> {
  late GoogleMapController mapController;
  Set<Polygon> _polygons = {}; // Store the created polygons
  double _area = 0.0; // Store the calculated area
  bool _afterReset = false;

  final LatLng _center = const LatLng(-6.98278742501218, 110.41159620896708);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _calculateArea() {
    double area = 0.0;
    for (Polygon polygon in _polygons) {
      List<LatLng> points = polygon.points;
      for (int i = 0; i < points.length - 1; i++) {
        LatLng p1 = points[i];
        LatLng p2 = points[i + 1];
        area += (p2.latitude - p1.latitude) * (p2.longitude + p1.longitude);
      }
    }
    setState(() {
      _area = (area.abs() / 2) * 111319.9; // Convert to square meters
    });
  }

  void _resetPolygon() {
    setState(() {
      _polygons = {};
      _area = 0.0;
      _afterReset = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.green[700],
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Maps Sample App'),
          elevation: 2,
        ),
        body: Stack(
          children: [
            GestureDetector(
              onTap: () {}, // Add an empty onTap handler to prevent clicks on the map from counting as onTap
              child: GoogleMap(
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: _center,
                  zoom: 11.0,
                ),
                polygons: _polygons,
                onTap: (LatLng latLng) {
                  setState(() {
                    List<LatLng> points = [];
                    if (_afterReset){
                      _afterReset = false;
                    }
                    else {
                      points.add(latLng);
                    }
                    if (_polygons.isNotEmpty) {
                      points.addAll(_polygons.first.points);
                    }
                    _polygons = {
                      Polygon(
                        polygonId: PolygonId('polygon'),
                        points: points,
                        strokeWidth: 2,
                        strokeColor: Colors.red,
                        fillColor: Colors.red.withOpacity(0.3),
                      ),
                    };
                    _calculateArea();
                  });
                },
              ),
            ),
            Positioned(
              bottom: 16,
              left: 16,
              child: Text(
                'Area: $_area',
                style: TextStyle(fontSize: 18),
              ),
            ),
            Positioned(
              bottom: 16,
              right: 16,
              child: ElevatedButton(
                onPressed: _resetPolygon,
                child: Text('Reset'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}