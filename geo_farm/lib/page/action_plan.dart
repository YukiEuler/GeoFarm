import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ActionPlanPage extends StatefulWidget {
  @override
  _ActionPlanPageState createState() => _ActionPlanPageState();
}

class _ActionPlanPageState extends State<ActionPlanPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? userEmail = '';
  TextEditingController _actionPlanController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getUserEmail();
  }

  void getUserEmail() async {
    User? user = _auth.currentUser;
    setState(() {
      userEmail = user?.email;
    });
  }

  void addToDoItem(String item) {
    _firestore.collection('todos').add({
      'email': userEmail,
      'item': item,
    });
  }

  Future<List<DocumentSnapshot>> getUserActionPlan() async {
    QuerySnapshot querySnapshot = await _firestore
        .collection('todos')
        .where('email', isEqualTo: userEmail)
        .get();
    return querySnapshot.docs;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Action Plan'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _actionPlanController,
            onChanged: (value) {
              // Store the value in a variable or state
            },
            decoration: InputDecoration(
              labelText: 'Add an Action Plan',
            ),
          ),
          ElevatedButton(
            onPressed: () {
              String actionPlan = _actionPlanController.text;
              addToDoItem(actionPlan);
              _actionPlanController.clear();
            },
            child: Text('Add'),
          ),
          Expanded(
            child: FutureBuilder<List<DocumentSnapshot>>(
              future: getUserActionPlan(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  List<DocumentSnapshot> userActionPlan = snapshot.data!;
                  return ListView.builder(
                    itemCount: userActionPlan.length,
                    itemBuilder: (context, index) {
                      var todo = userActionPlan[index];
                      return ListTile(
                        title: Text(todo['item']),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
