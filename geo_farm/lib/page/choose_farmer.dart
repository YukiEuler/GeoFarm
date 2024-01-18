import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'talk_with_expert.dart';

class ChooseFarmerPage extends StatefulWidget {
  const ChooseFarmerPage({super.key});

  @override
  _ChooseFarmerPageState createState() => _ChooseFarmerPageState();
}

class _ChooseFarmerPageState extends State<ChooseFarmerPage> {
  String? _getCurrentUser() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return user.email;
    }
    return '';
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose Farmer'),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection('pakarHistoryChat').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Farmer> farmers = snapshot.data!.docs
              .map((doc) => Farmer.fromSnapshot(doc))
              .where((farmer) => farmer.pakar == _getCurrentUser())
              .toList();
            return ListView.builder(
              itemCount: farmers.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(farmers[index].email), // Add null check
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatPage(chatRoomId: '${farmers[index].email}-${_getCurrentUser()}',),
                      ),
                    );
                  },
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}

class Farmer {
  final String pakar;
  final String email;

  Farmer({required this.pakar, required this.email});

  factory Farmer.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
    return Farmer(
      pakar: snapshot.id,
      email: data?['senderId'],
    );
  }
}