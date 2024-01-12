import 'package:flutter/material.dart';

class MainMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
                  // Handle 'Land Maps' button press
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
                  // Handle 'Talk with Expert' button press
                },
              ),
              _buildButton(
                text: 'Action Plan',
                onPressed: () {
                  // Handle 'Action Plan' button press
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
        child: Text(
          text,
          style: TextStyle(fontSize: 20), // Set the font size of the button text
        ),
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0), // Set the border radius
          ),
          minimumSize: Size(double.infinity, 100), // Set the minimum size of the button
        ),
      ),
    );
  }
}
