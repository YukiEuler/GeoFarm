import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatPage extends StatefulWidget {
  final String chatRoomId;

  const ChatPage({Key? key, required this.chatRoomId}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  late List<String> email;
  late String _senderId;

  @override
  void initState() {
    super.initState();
    print(widget.chatRoomId);
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        _senderId = user.email!;
      });
    }
    email = widget.chatRoomId.split('-');
    final String pakarId = email[1];

    // Add data into 'pakarHistoryChat' collection if it's the first message
    FirebaseFirestore.instance
        .collection('pakarHistoryChat')
        .doc(widget.chatRoomId)
        .get()
        .then((docSnapshot) {
      if (!docSnapshot.exists) {
        FirebaseFirestore.instance
            .collection('pakarHistoryChat')
            .doc(pakarId)
            .set({
          'chatRoomId': widget.chatRoomId,
          'senderId': _senderId,
          'timestamp': FieldValue.serverTimestamp(),
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat Room'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('chatRooms')
                  .doc(widget.chatRoomId)
                  .collection('messages')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                List<Map<String, dynamic>> messages = snapshot.data!.docs
                    .map((doc) => doc.data() as Map<String, dynamic>)
                    .toList();

                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final isSentByCurrentUser =
                        message['senderId'] == _senderId;

                    return ListTile(
                      title: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 14,
                        ),
                        decoration: BoxDecoration(
                          color: isSentByCurrentUser
                              ? Colors.blue
                              : Colors.grey[300],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          message['text'],
                          style: TextStyle(
                            color: isSentByCurrentUser
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ),
                      subtitle: Text(message['senderId']),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Type a message...',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    String messageText = _messageController.text.trim();
                    if (messageText.isNotEmpty) {
                      sendMessage(widget.chatRoomId, messageText, _senderId);
                      _messageController.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void sendMessage(String chatRoomId, String messageText, String senderId) {
    FirebaseFirestore.instance
        .collection('chatRooms')
        .doc(chatRoomId)
        .collection('messages')
        .add({
      'text': messageText,
      'senderId': senderId,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}
