import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:geo_farm/firebase_options.dart';
import 'package:geo_farm/page/starting.dart';

Future main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GeoFarm',
      routes: {
        '/': (context) => const StartingWidget()
      }
    );
  }
}