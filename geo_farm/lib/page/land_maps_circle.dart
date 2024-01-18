import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'land_maps.dart';
import 'dart:math';

class LandMapsCirclePage extends StatefulWidget {
  const LandMapsCirclePage({Key? key}) : super(key: key);

  @override
  State<LandMapsCirclePage> createState() => _LandMapsCirclePageState();
}

class _LandMapsCirclePageState extends State<LandMapsCirclePage> {
  late GoogleMapController mapController;
  Set<Circle> _circles = {}; // Store the created circles
  double _area = 0.0; // Store the calculated area
  bool _afterReset = false; // Store the state after first reset
  double _radius = 100.0; // Initial radius value

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
    double area = 0.0;
    for (Circle circle in _circles) {
      double circleRadius = circle.radius;
      double circleArea = pi * circleRadius * circleRadius;
      area += circleArea;
    }
    setState(() {
      _area = area;
    });
  }

  void _resetCircle() {
    setState(() {
      _circles = {};
      _area = 0.0;
      _afterReset = true;
    });
  }

  void _updateRadius(double newRadius) {
    setState(() {
      _radius = newRadius;
      _circles = _circles.map((circle) {
        return Circle(
          circleId: circle.circleId,
          center: circle.center,
          radius: newRadius,
          strokeWidth: circle.strokeWidth,
          strokeColor: circle.strokeColor,
          fillColor: circle.fillColor,
        );
      }).toSet();
      _calculateArea();
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
                circles: _circles,
                onTap: (LatLng latLng) {
                  setState(() {
                    if (_afterReset){
                      _afterReset = false;
                    }
                    else {
                      _circles = {
                        Circle(
                          circleId: const CircleId('circle'),
                          center: latLng,
                          radius: _radius, // Use the updated radius value
                          strokeWidth: 2,
                          strokeColor: Colors.red,
                          fillColor: Colors.red.withOpacity(0.3),
                        ),
                      };
                      _calculateArea();
                    }
                  });
                },
              ),
            ),
            Positioned(
              top: 16,
              left: 16,
              child: Text(
                'Area: $_area',
                style: const TextStyle(fontSize: 18),
              ),
            ),
            Positioned(
              bottom: 16,
              left: 16,
              child: ElevatedButton(
                  onPressed: _resetCircle,
                  child: const Text('Reset'),
                )
            ),
            Positioned(
              bottom: 16,
              right: 16,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LandMapsPage()),
                  );
                },
                child: const Text('Switch to Polygon Page'),
              ),
            ),
            Positioned(
              top: 16,
              right: 16,
              child: Slider(
                value: _radius,
                min: 0,
                max: 500,
                onChanged: _updateRadius,
              ),
            ),
          ],
        ),
      ),
    );
  }
}