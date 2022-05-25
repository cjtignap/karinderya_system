import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:karinderya_system/models/store_data.dart';
import 'package:karinderya_system/widgets/store_app_bar.dart';
import '../constants.dart';
import '../screens/add_item.dart';
import 'package:provider/provider.dart';

class StoreScreen extends StatefulWidget {
  StoreScreen({required this.user, required this.auth});
  static const id = '/store';
  final storage = FirebaseStorage.instance;
  final fireStore = FirebaseFirestore.instance;
  final FirebaseAuth auth;
  final User user;
  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => StoreData(
        user: widget.user,
        auth: widget.auth,
        storage: widget.storage,
        firestore: widget.fireStore,
      ),
      child: SafeArea(
        child: Scaffold(
          body: StoreAppBar(),
          backgroundColor: Colors.white,
          floatingActionButton: FloatingActionButton(
              onPressed: () {
                showModalBottomSheet(
                    context: context, builder: (context) => AddItem());
              },
              child: const Icon(Icons.add),
              foregroundColor: kPrimaryColor,
              backgroundColor: kAccentColor),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: BottomAppBar(
            color: kPrimaryColor,
            shape: CircularNotchedRectangle(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.list_alt),
                  tooltip: 'Deliveries',
                  color: Colors.white,
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.chat_outlined),
                  tooltip: 'Messages',
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
