import 'package:flutter/material.dart';

class PlantRecommendationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plant Recommendation'),
      ),
      body: Column(
        children: [
          buildColumnWithImage('Soil Preparation', '1-2 Month', 'images/soil_preparation.png'),
          const SizedBox(width: 8),
          buildColumnWithImage('Seed Planting', '2-3 Month', 'images/seed_planting.png'),
          const SizedBox(width: 8),
          buildColumnWithImage('Routine Care (until harvest)', '3-4 Month', 'images/routine_care.png'),
        ],
      ),
    );
  }

  Widget buildColumnWithImage(String title, String subtitle, String imagePath) {
    return Row(
      children: [
        Image.asset(
          imagePath,
          width: 50,
          height: 50,
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
