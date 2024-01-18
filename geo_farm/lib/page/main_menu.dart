import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geo_farm/page/action_plan.dart';
import 'package:geo_farm/page/choose_expert.dart';
import 'package:geo_farm/page/land_maps.dart';
import 'package:geo_farm/page/starting.dart';
import 'package:geo_farm/page/plant_recomendation.dart';

class MainMenu extends StatelessWidget {
  const MainMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const StartingWidget()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Main Menu'),
      ),
      body: Container(
        color: const Color(0xFF61876E), // Set the background color
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Adjust the spacing between buttons
            children: [
              _buildButton(
                text: 'Land Maps',
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LandMapsPage()),
                    );
                },
              ),
              _buildButton(
                text: 'Plant Schedule',
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PlantRecommendationPage()),
                    );
                },
              ),
              _buildButton(
                text: 'Talk with Expert',
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ChooseExpertPage()),
                    );
                },
              ),
              _buildButton(
                text: 'Action Plan',
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ActionPlanPage()),
                    );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton({required String text, required VoidCallback onPressed}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              colors: [Color(0xFF61876E), Color(0xFF123456)],
              // begin: Alignment.topLeft,
              // end: Alignment.bottomRight,
            ),
        ),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0.0),
            ),
            minimumSize: const Size(double.infinity, 100),
            // Add a color gradient for the button background
          ),
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 20,
              fontFamily: 'Inter',
            ),
          ),
        ),
      ),
    );
  }
}