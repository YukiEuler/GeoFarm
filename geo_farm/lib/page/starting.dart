import 'package:flutter/material.dart';
import 'dart:math';
import 'login.dart';
import 'register.dart';

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
                      MaterialPageRoute(builder: (context) => LoginPage()),
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
                      MaterialPageRoute(builder: (context) => RegisterPage()),
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
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        primary: const Color.fromRGBO(97, 135, 110, 1),
        minimumSize: Size(
          min(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height) / 2,
          min(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height) / 8,
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
        ),
      ),
    );
  }
}