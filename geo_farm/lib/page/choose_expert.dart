import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'talk_with_expert.dart';

class ChooseExpertPage extends StatefulWidget {
  @override
  _ChooseExpertPageState createState() => _ChooseExpertPageState();
}

class _ChooseExpertPageState extends State<ChooseExpertPage> {
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
        title: Text('Choose Expert'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('pakar').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Expert> experts = snapshot.data!.docs
                .map((doc) => Expert.fromSnapshot(doc))
                .toList();
            return ListView.builder(
              itemCount: experts.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(experts[index].nama), // Add null check
                  subtitle: Text(experts[index].role), // Add null check
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatPage(chatRoomId: '${_getCurrentUser()}-${experts[index].email}',),
                      ),
                    );
                  },
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }
}

class Expert {
  final String email;
  final String nama;
  final String role;

  Expert({required this.email, required this.nama, required this.role});

  factory Expert.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?; // Add null check
    return Expert(
      email: snapshot.id,
      nama: data?['Nama'] ?? '', // Add null check
      role: data?['Role'] ?? '', // Add null check
    );
  }
}