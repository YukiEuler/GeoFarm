import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'main_menu.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xFF61876E),
        child: Stack(
          children: [
            Transform.scale(
              scale: 0.3,
              child: Image.asset(
                'images/Geofarm1.png',
                fit: BoxFit.fitWidth,
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end, // Align the form to the bottom
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFEAE7B1),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(100.0),
                      topRight: Radius.circular(100.0),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        blurRadius: 25,
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                  height: MediaQuery.of(context).size.height / 1.75,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(bottom: 50.0),
                        child: Text(
                          'Welcome Back',
                          style: TextStyle(
                            fontSize: 30,
                            color: Color(0xFF61876E),
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ),
                      TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          prefixIcon: Image.asset('images/vector.png'),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      TextField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: Image.asset('images/vector.png'),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                          ),
                        ),
                        obscureText: _obscurePassword,
                      ),
                      const SizedBox(height: 16.0),
                      ElevatedButton(
                        onPressed: () {
                          _login();
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          backgroundColor: const Color.fromRGBO(97, 135, 110, 1),
                          shadowColor: Colors.black.withOpacity(0.5), // Add shadow color
                          elevation: 20, // Add elevation for shadow effect
                        ),
                        child: const Text(
                          'Login',
                          style: TextStyle(
                            color: Color(0xFFEAE7B1),
                            fontFamily: 'Inter',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _login() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      // Handle successful login
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const MainMenu()),
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: e.toString(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }
}
