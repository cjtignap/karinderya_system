import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'user_details.dart';
import 'dart:io';

import 'package:karinderya_system/models/item.dart';

class StoreData extends ChangeNotifier {
  final User user;
  final FirebaseAuth auth;
  final FirebaseStorage storage;
  final FirebaseFirestore firestore;
  // UserDetails userDetails;

  List<Item> _items = [];
  StoreData({
    required this.user,
    required this.auth,
    required this.storage,
    required this.firestore,
    // required this.userDetails,
  });
  Future<void> logOut() async {
    await auth.signOut();
  }

  Future<void> uploadImage(File file) async {
    await storage.ref().putFile(file);
  }

  Future<void> uploadItem(
      String foodName, String quantity, String price, String imageName) async {
    await firestore.collection('live_items').add({
      'karinderya_name': user.email,
      'food_name': foodName,
      'price': price,
      'quantity': quantity,
      'image_name': imageName,
    });
  }

  List<Item> get items {
    return _items;
  }

  void addItem(Item item) {
    _items.add(item);
    notifyListeners();
  }

  Item getItem(int index) {
    return _items[index];
  }
}
