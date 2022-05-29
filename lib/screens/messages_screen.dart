import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:karinderya_system/constants.dart';

import 'messages.dart';

class MessagesScreen extends StatelessWidget {
  final controller = TextEditingController();
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;

  final String name;

  MessagesScreen({required this.name});

  @override
  Widget build(BuildContext context) {
    String message = '';
    Future.delayed(const Duration(),
        () => SystemChannels.textInput.invokeMethod('TextInput.hide'));
    User currentUser = _auth.currentUser!;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(name),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(
                child: FutureBuilder(
                  future: _firestore
                      .collection('user_details')
                      .where('email', isEqualTo: _auth.currentUser!.email)
                      .get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      var qSnap =
                          snapshot.data as QuerySnapshot<Map<String, dynamic>>;
                      var userDetailMap = qSnap.docs.first;
                      return Messages(
                        currentUser: userDetailMap.get('name'),
                        name: name,
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.lightBlueAccent,
                        ),
                      );
                    }
                  },
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(width: 2, color: kPrimaryColor),
                  ),
                ),
                width: double.infinity,
                child: Row(
                  children: [
                    Flexible(
                      child: TextField(
                        controller: controller,
                        maxLines: null,
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Enter your message here'),
                        autofocus: true,
                        onChanged: (newText) {
                          message = newText;
                        },
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        var snapshot = await _firestore
                            .collection('user_details')
                            .where('email', isEqualTo: currentUser.email)
                            .get();
                        var result = snapshot.docs.first;

                        await _firestore.collection('messages').add({
                          'sender': result.get('name'),
                          'message': message,
                          'receiver': name,
                          'convo-id': name.compareTo(result.get('name')) <= 0
                              ? '$name${result.get('name')}'
                              : '${result.get('name')}$name',
                          'timestamp': DateTime.now().millisecondsSinceEpoch
                        });

                        controller.clear();
                      },
                      child: Image.asset(
                        'images/send.png',
                        height: 30,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
