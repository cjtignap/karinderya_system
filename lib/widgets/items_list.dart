import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:karinderya_system/models/item.dart';
import 'package:karinderya_system/models/store_data.dart';
import 'package:provider/provider.dart';
import '../constants.dart';
import './item_view.dart';

class ItemList extends StatefulWidget {
  @override
  State<ItemList> createState() => _ItemListState();
}

class _ItemListState extends State<ItemList> {
  final FirebaseStorage? storage = FirebaseStorage.instance;
  final FirebaseFirestore? fireStore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    fireStore!
        .collection('live_items')
        .get()
        .then((value) => {setStoreDataItems(value)});
  }

  setStoreDataItems(QuerySnapshot result) {
    for (var item in result.docs) {
      var newItem = Item(
        itemName: item.get('food_name'),
        quantity: item.get('quantity'),
        price: item.get('price'),
        karinderyaName: item.get('karinderya_name'),
        imageName: item.get('image_name'),
        description: item.get('description'),
      );
      Provider.of<StoreData>(context, listen: false).addItem(newItem);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemBuilder: (context, index) {
          return ItemView(item: Provider.of<StoreData>(context).getItem(index));
        },
        itemCount: Provider.of<StoreData>(context).items.length,
      ),
    );
  }
}
