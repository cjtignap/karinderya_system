import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:karinderya_system/models/store_data.dart';
import 'package:karinderya_system/models/user_details.dart';
import 'package:karinderya_system/screens/karinderya_order_history.dart';
import 'package:karinderya_system/screens/order_queue.dart';
import 'package:karinderya_system/widgets/items_list.dart';
import 'package:karinderya_system/widgets/store_app_bar.dart';
import '../constants.dart';
import '../screens/add_item.dart';
import 'package:provider/provider.dart';

class StoreScreen extends StatefulWidget {
  StoreScreen({
    required this.user,
    required this.auth,
    required this.userDetails,
  });

  final FirebaseAuth auth;
  final User user;
  final UserDetails userDetails;
  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  String currentScreen = 'ITEM_LIST';
  final FirebaseStorage? storage = FirebaseStorage.instance;
  final FirebaseFirestore? fireStore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => StoreData(
        user: widget.user,
        auth: widget.auth,
        storage: storage!,
        firestore: fireStore!,
      ),
      child: SafeArea(
        child: Scaffold(
          extendBody: true,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              StoreAppBar(),
              currentScreen == 'ITEM_LIST'
                  ? ItemList(userDetails: widget.userDetails)
                  : currentScreen == 'ORDER_QUEUE'
                      ? OrderQueue(userDetails: widget.userDetails)
                      : KarinderyaHistory(
                          karinderyaName: widget.userDetails.name),
            ],
          ),
          backgroundColor: Colors.white,
          floatingActionButton: FloatingActionButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => AddItem(
                    userDetails: widget.userDetails,
                  ),
                );
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
                  onPressed: () {
                    setState(() {
                      if (currentScreen != 'ITEM_LIST') {
                        currentScreen = 'ITEM_LIST';
                      }
                    });
                  },
                  icon: Icon(Icons.list_alt),
                  tooltip: 'Item List',
                  color: Colors.white,
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          if (currentScreen != 'ORDER_QUEUE') {
                            currentScreen = 'ORDER_QUEUE';
                          }
                        });
                      },
                      icon: Icon(Icons.queue),
                      tooltip: 'Order Queue',
                      color: Colors.white,
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          if (currentScreen != 'ORDER_HISTORY') {
                            currentScreen = 'ORDER_HISTORY';
                          }
                        });
                      },
                      icon: Icon(Icons.history),
                      tooltip: 'History',
                      color: Colors.white,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
