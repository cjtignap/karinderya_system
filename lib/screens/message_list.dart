import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:karinderya_system/constants.dart';
import 'package:karinderya_system/models/user_details.dart';
import 'package:karinderya_system/screens/messages_screen.dart';

class MessageList extends StatelessWidget {
  List<String> names = [];
  List<ConversationTile> conversationTiles = [];

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  final UserDetails userDetails;
  MessageList({required this.userDetails});
  QuerySnapshot<dynamic>? messages;
  String? userType;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Messages'),
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: userDetails.userType == 'customer'
                ? _firestore
                    .collection('messages')
                    .where('sender', isEqualTo: userDetails.name)
                    .snapshots()
                : _firestore
                    .collection('messages')
                    .where('receiver', isEqualTo: userDetails.name)
                    .snapshots(),
            builder: (context, snapshots) {
              if (snapshots.hasData) {
                final result = snapshots.data;
                var messages = result!.docs;

                for (var message in messages) {
                  if (userDetails.name == message.get('sender')) {
                    if (names.contains(message.get('receiver'))) {
                      continue;
                    } else {
                      conversationTiles
                          .add(ConversationTile(name: message.get('receiver')));

                      names.add(message.get('receiver'));
                    }
                  } else if (userDetails.name == message.get('receiver')) {
                    if (names.contains(message.get('sender'))) {
                      continue;
                    } else {
                      conversationTiles
                          .add(ConversationTile(name: message.get('sender')));

                      names.add(message.get('sender'));
                    }
                  }
                }

                return ListView(
                  children: conversationTiles,
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.lightBlueAccent,
                  ),
                );
              }
            }),
        backgroundColor: Colors.white,
      ),
    );
  }
}

class ConversationTile extends StatelessWidget {
  final String name;

  ConversationTile({required this.name});
  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5,
      child: ListTile(
        contentPadding: EdgeInsets.all(10),
        leading: const Icon(
          Icons.account_circle,
          size: 40,
        ),
        title: Text(name),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MessagesScreen(
                name: name,
              ),
            ),
          );
        },
      ),
    );
  }
}
