import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:karinderya_system/constants.dart';
import 'package:karinderya_system/models/store_data.dart';
import 'package:karinderya_system/models/user_details.dart';
import 'package:karinderya_system/screens/message_list.dart';
import 'package:karinderya_system/screens/messages_screen.dart';
import '../screens/login.dart';

class StoreAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5,
      child: Container(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ProfileDropdown(),
            ],
          ),
        ),
        width: double.infinity,
        color: kPrimaryColor,
      ),
    );
  }
}

class ProfileDropdown extends StatefulWidget {
  @override
  State<ProfileDropdown> createState() => _ProfileDropdownState();
}

class _ProfileDropdownState extends State<ProfileDropdown> {
  String currentItem = 'profile';

  List<DropdownMenuItem<String>> dropdownItems = [
    DropdownMenuItem(
      child:
          ContextItem(image: AssetImage('images/bojji.png'), text: 'Profile'),
      value: 'profile',
    ),
    DropdownMenuItem(
      child: ContextItem(
          image: AssetImage('images/messenger.jpg'), text: 'Messages'),
      value: 'messages',
    ),
    DropdownMenuItem(
      child:
          ContextItem(image: AssetImage('images/logout.png'), text: 'Logout'),
      value: 'logout',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        items: dropdownItems,
        onChanged: (contextItem) {
          setState(() async {
            currentItem = contextItem!;

            if (contextItem == 'logout') {
              await FirebaseAuth.instance.signOut();
              Navigator.pop(context);
            } else if (contextItem == 'messages') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: ((context) => FutureBuilder(
                        future: FirebaseFirestore.instance
                            .collection('user_details')
                            .where('email',
                                isEqualTo:
                                    FirebaseAuth.instance.currentUser!.email)
                            .get(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            var qSnap = snapshot.data
                                as QuerySnapshot<Map<String, dynamic>>;
                            var userDetailMap = qSnap.docs.first;
                            return MessageList(
                              userDetails: UserDetails(
                                name: userDetailMap.get('name'),
                                userType: userDetailMap.get('user_type'),
                              ),
                            );
                          } else {
                            return const Center(
                              child: CircularProgressIndicator(
                                backgroundColor: Colors.lightBlueAccent,
                              ),
                            );
                          }
                        },
                      )),
                ),
              );
            }
          });
        },
        dropdownColor: kPrimaryColor,
        value: currentItem,
      ),
    );
  }
}

class ContextItem extends StatelessWidget {
  final ImageProvider image;
  final String text;

  ContextItem({required this.image, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 10),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: kPrimaryColor,
            backgroundImage: image,
            radius: 15,
          ),
          const SizedBox(
            width: 5,
          ),
          Text(
            text,
            style: TextStyle(color: Colors.white),
          ),
        ],
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      ),
    );
  }
}
