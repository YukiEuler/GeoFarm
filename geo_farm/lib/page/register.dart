import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'main_menu.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _reenterPasswordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final CollectionReference _usersCollection = FirebaseFirestore.instance.collection('users'); // Firestore collection reference

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: Center( // Center the content
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Center the column vertically
            children: [
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                ),
              ),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                ),
              ),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                ),
                obscureText: true,
              ),
              TextField(
                controller: _reenterPasswordController,
                decoration: InputDecoration(
                  labelText: 'Re-enter Password',
                ),
                obscureText: true,
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  _register();
                },
                child: Text('Register'),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  _registerWithGoogle();
                },
                child: Text('Register with Google'),
              ),
            ],
          ),
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
        MaterialPageRoute(builder: (context) => MainMenu()),
      );
    } catch (e) {
      Fluttertoast.showToast(
          msg: e.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
    }
  }

  void _registerWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      UserCredential userCredential = await _auth.signInWithCredential(credential);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MainMenu()),
      );
    } catch (e) {
      // Registration with Google failed, handle the error
      print(e.toString());
    }
  }
}
