import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:karinderya_system/models/item.dart';
import 'package:karinderya_system/models/store_data.dart';
import 'package:karinderya_system/models/user_details.dart';
import 'package:provider/provider.dart';
import '../constants.dart';
import './item_view.dart';

class ItemList extends StatefulWidget {
  @override
  State<ItemList> createState() => _ItemListState();

  final UserDetails userDetails;
  ItemList({required this.userDetails});
}

class _ItemListState extends State<ItemList> {
  final FirebaseStorage storage = FirebaseStorage.instance;
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: fireStore
          .collection('live_items')
          .where('karinderya_name', isEqualTo: widget.userDetails.name)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }

        final items = snapshot.data!.docs;
        List<ItemView> itemViews = [];

        for (var item in items) {
          var itemName = item.get('food_name');
          var imageName = item.get('image_name');
          var description = item.get('description');
          var karinderyaName = item.get('karinderya_name');
          var price = item.get('price');
          var quantity = item.get('quantity');

          final itemObject = Item(
            itemName: itemName,
            quantity: quantity,
            price: price,
            karinderyaName: karinderyaName,
            imageName: imageName,
            description: description,
          );
          itemViews.add(ItemView(item: itemObject));
        }
        return Expanded(
          child: ListView(
            children: itemViews,
          ),
        );
      },
    );
  }
}
