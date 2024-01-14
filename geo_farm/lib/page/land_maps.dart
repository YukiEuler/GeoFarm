import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'land_maps_circle.dart';
import 'dart:math';

class LandMapsPage extends StatefulWidget {
  const LandMapsPage({Key? key}) : super(key: key);

  @override
  State<LandMapsPage> createState() => _LandMapsPageState();
}

class _LandMapsPageState extends State<LandMapsPage> {
  late GoogleMapController mapController;
  Set<Polygon> _polygons = {}; // Store the created polygons
  double _area = 0.0; // Store the calculated area
  bool _afterReset = false; // Store the state after first reset

  final LatLng _center = const LatLng(-6.98278742501218, 110.41159620896708);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  double toRadians(double degree){
    return pi/180*degree;
  }

  double polarTriangleArea(double tan1, double lng1, double tan2, double lng2) {
    double deltaLng = lng1 - lng2;
    double t = tan1 * tan2;
    return 2 * atan2(t * sin(deltaLng), 1 + t * cos(deltaLng));
  }

  void _calculateArea() {
    const double radius = 6371009;
    double area = 0.0;
    for (Polygon polygon in _polygons) {
      List<LatLng> points = polygon.points;
      int size = points.length;
      if (size >= 3) {
        LatLng prev = points[size - 1];
        double prevTanLat = tan((pi / 2 - toRadians(prev.latitude)) / 2);
        double prevLng = toRadians(prev.longitude);
        for (LatLng point in points) {
          double tanLat = tan((pi / 2 - toRadians(point.latitude)) / 2);
          double lng = toRadians(point.longitude);
          area += polarTriangleArea(tanLat, lng, prevTanLat, prevLng);
          prevTanLat = tanLat;
          prevLng = lng;
        }
      }
    }
    setState(() {
      _area = (area * (radius * radius)).abs(); // SphericalUtilTest
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
                        polygonId: const PolygonId('polygon'),
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
                style: const TextStyle(fontSize: 18),
              ),
            ),
            Positioned(
              bottom: 16,
              right: 16,
              child: ElevatedButton(
                onPressed: _resetPolygon,
                child: const Text('Reset'),
              ),
            ),
            Positioned(
              bottom: 16,
              right: 96,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LandMapsCirclePage()),
                  );
                },
                child: const Text('Switch to Circle Page'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}