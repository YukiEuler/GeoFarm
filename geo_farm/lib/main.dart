import 'package:flutter/material.dart';
//import 'package:geo_farm/page/starting.dart';
// import 'package:geo_farm/page/land_maps.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:geo_farm/page/starting.dart';
import 'package:geo_farm/firebase_options.dart';

Future main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
  }

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GeoFarm',
      routes: {
        '/': (context) => StartingWidget()
      }
    );
  }
}