import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants.dart';
import '../models/store_data.dart';
import '../models/item.dart';

class ItemView extends StatefulWidget {
  final Item item;
  ItemView({required this.item});

  @override
  State<ItemView> createState() => _ItemViewState();
}

class _ItemViewState extends State<ItemView> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String imageURL = '';
  @override
  Widget build(BuildContext context) {
    Reference ref = Provider.of<StoreData>(context)
        .storage
        .ref('/food_images')
        .child(widget.item.imageName);
    return Column(
      children: [
        Material(
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Container(
              width: double.infinity,
              child: Row(
                children: [
                  FutureBuilder(
                    future: ref.getDownloadURL(),
                    builder: (context, snapshot) {
                      return Image(
                        image: snapshot.data != null
                            ? NetworkImage(snapshot.data.toString())
                            : AssetImage('images/welcome_banner.png')
                                as ImageProvider,
                        width: 130,
                      );
                    },
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.item.itemName,
                          style: const TextStyle(
                            color: kPrimaryColor,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(widget.item.karinderyaName),
                        SizedBox(height: 10),
                        Text(
                          widget.item.description,
                          style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            Column(
                              children: [
                                Text(
                                  'Php ${widget.item.price} per serving',
                                  style: const TextStyle(fontSize: 13),
                                ),
                                Text(
                                  '${widget.item.quantity} servings left',
                                  style: const TextStyle(fontSize: 13),
                                ),
                              ],
                              crossAxisAlignment: CrossAxisAlignment.start,
                            ),
                            GestureDetector(
                              child: const Icon(
                                Icons.delete,
                                size: 20,
                                color: kPrimaryColor,
                              ),
                              onTap: () async {
                                await _firestore
                                    .collection('live_items')
                                    .doc(widget.item.docId)
                                    .delete();
                              },
                            ),
                          ],
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          elevation: 5,
        ),
        const SizedBox(
          height: 10,
        )
      ],
    );
  }
}
