import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'main_menu.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _reenterPasswordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final CollectionReference _usersCollection = FirebaseFirestore.instance.collection('users'); // Firestore collection reference
  bool _obscurePassword = true;
  bool _obscureValidatePassword = true;

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
                      const Text(
                          'Create Account',
                          style: TextStyle(
                            fontSize: 30,
                            color: Color(0xFF61876E),
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Inter',
                          ),
                        ),
                      TextField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                          labelText: 'Username',
                          prefixIcon: Image.asset('images/vector.png'),
                        ),
                      ),
                      TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          prefixIcon: Image.asset('images/vector.png'),
                        ),
                      ),
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
                      TextField(
                        controller: _reenterPasswordController,
                        decoration: InputDecoration(
                          labelText: 'Re-enter Password',
                          prefixIcon: Image.asset('images/vector.png'),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _obscureValidatePassword = !_obscureValidatePassword;
                              });
                            },
                            icon: Icon(
                              _obscureValidatePassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                          ),
                        ),
                        obscureText: _obscureValidatePassword,
                      ),
                      const SizedBox(height: 16.0),
                      ElevatedButton(
                        onPressed: () {
                          _register();
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
                          'Register',
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

  void _register() async {
    try {
      String email = _emailController.text;
      String password = _passwordController.text;
      String reenterPassword = _reenterPasswordController.text;
      String username = _usernameController.text;

      // Validate re-entered password
      if (password != reenterPassword) {
        // Passwords do not match, handle the error
        Fluttertoast.showToast(
          msg: 'Passwords do not match',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
        return;
      }

      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Additional data (username)
      await userCredential.user!.updateDisplayName(username);

      // Add user data to Firestore collection
      await _usersCollection.doc(email).set({
        'username': username,
        'registrationDate': DateTime.now(),
      });

      // Registration successful, do something with the userCredential
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
