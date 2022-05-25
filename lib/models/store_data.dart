import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';

class StoreData extends ChangeNotifier {
  final User user;
  final FirebaseAuth auth;
  final FirebaseStorage storage;
  final FirebaseFirestore firestore;
  StoreData(
      {required this.user,
      required this.auth,
      required this.storage,
      required this.firestore});
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
}
