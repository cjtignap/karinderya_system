import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:karinderya_system/constants.dart';
import 'package:karinderya_system/models/user_details.dart';
import 'package:karinderya_system/screens/customer_history.dart';
import 'package:karinderya_system/screens/customer_item_list.dart';
import 'package:karinderya_system/widgets/store_app_bar.dart';

class CustomerScreen extends StatelessWidget {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final UserDetails userDetails;

  CustomerScreen({required this.userDetails});

  @override
  Widget build(BuildContext context) {
    User currentUser = _firebaseAuth.currentUser!;
    return SafeArea(
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            children: [
              StoreAppBar(),
              Container(
                color: kPrimaryColor,
                child: const TabBar(
                  labelColor: Colors.white,
                  tabs: [
                    Tab(
                      icon: Icon(Icons.store),
                    ),
                    Tab(
                      icon: Icon(Icons.history),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    CustomerItemList(
                      userDetails: userDetails,
                    ),
                    CustomerHistory(userDetails: userDetails),
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
