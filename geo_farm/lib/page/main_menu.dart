import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geo_farm/page/action_plan.dart';
import 'package:geo_farm/page/choose_expert.dart';
import 'package:geo_farm/page/land_maps.dart';
import 'package:geo_farm/page/starting.dart';
//import 'talk_with_expert.dart';

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
                  // Handle 'Plant Schedule' button press
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
      padding: const EdgeInsets.symmetric(horizontal: 16.0), // Add margin to the left and right side
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0), // Set the border radius
          ),
          minimumSize: const Size(double.infinity, 100), // Set the minimum size of the button
        ),
        child: Text(
          text,
          style: const TextStyle(fontSize: 20), // Set the font size of the button text
        ),
      ),
    );
  }
}
