import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:karinderya_system/constants.dart';

class Messages extends StatelessWidget {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;

  final String currentUser;
  String? convoId;
  final String name;

  Messages({required this.name, required this.currentUser});

  void setCurrentUser() async {
    convoId = name.compareTo(currentUser) <= 0
        ? '$name${currentUser}'
        : '${currentUser}$name';
  }

  @override
  Widget build(BuildContext context) {
    setCurrentUser();

    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('messages')
          .where(
            'convo-id',
            isEqualTo: convoId,
          )
          .snapshots(),
      builder: (context, snapshots) {
        if (!snapshots.hasData) {
          return const Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }

        final messages = snapshots.data!.docs;
        List<Message> messageViews = [];

        for (var message in messages) {
          messageViews.add(
            Message(
              messageText: message.get('message'),
              isMe: message.get('sender') == currentUser,
              timestamp: message.get('timestamp'),
            ),
          );
        }

        messageViews.sort((a, b) {
          return b.timestamp.compareTo(a.timestamp);
        });
        return ListView(
          children: messageViews,
          reverse: true,
        );
      },
    );
  }
}

class Message extends StatelessWidget {
  final String messageText;
  final bool isMe;
  final int timestamp;
  Message(
      {required this.messageText, required this.isMe, required this.timestamp});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: !isMe ? Alignment.centerLeft : Alignment.centerRight,
          child: Material(
            borderRadius: !isMe ? kBorderRadiusIsNotMe : kBorderRadiusIsMe,
            elevation: 5,
            color: kPrimaryColor,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                messageText,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }
}

const kBorderRadiusIsMe = BorderRadius.only(
    topLeft: Radius.circular(30),
    bottomLeft: Radius.circular(30),
    bottomRight: Radius.circular(30));

const kBorderRadiusIsNotMe = BorderRadius.only(
    topRight: Radius.circular(30),
    bottomLeft: Radius.circular(30),
    bottomRight: Radius.circular(30));
