import 'package:flutter/material.dart';
import 'dart:math';

class StartingWidget extends StatelessWidget {
  const StartingWidget({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color.fromRGBO(234, 231, 177, 1),
        child: Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 300),
                child: Transform.scale(
                  scale: 0.4,
                  child: Image.asset(
                    'images/Geofarm1.png',
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 0),
                child: CustomButton(
                  text: 'Login',
                  onPressed: () {
                    // Handle login logic here
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const StartingWidget()), // TODO: Replace to Login
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 150),
                child: CustomButton(
                  text: 'Register',
                  onPressed: () {
                    // Handle register logic here
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const StartingWidget()), // TODO: Replace to Register
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  const CustomButton({
    required this.text,
    required this.onPressed,
  });

  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: min(min(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height)/2, 240),
      height: min(min(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height)/8, 60),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: const Color.fromRGBO(97, 135, 110, 1),
      ),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}