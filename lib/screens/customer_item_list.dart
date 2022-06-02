import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:karinderya_system/constants.dart';
import 'package:karinderya_system/models/user_details.dart';
import 'package:karinderya_system/widgets/add_to_cart.dart';

import '../widgets/view_karinderya_dialog.dart';

class CustomerItemList extends StatelessWidget {
  final UserDetails userDetails;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  CustomerItemList({required this.userDetails});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('live_items').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }

        final items = snapshot.data!.docs;
        List<Widget> itemViews = [];

        for (var item in items) {
          var itemName = item.get('food_name');
          var imageName = item.get('image_name');
          var description = item.get('description');
          var karinderyaName = item.get('karinderya_name');
          var price = item.get('price');
          var quantity = item.get('quantity');
          var docID = item.id;

          itemViews.add(
            Padding(
              padding: const EdgeInsets.only(
                left: 10.0,
                right: 10.0,
              ),
              child: Container(
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.black26,
                      width: 1,
                    ),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: ListTile(
                    leading: FutureBuilder(
                      future: _firebaseStorage
                          .ref('/food_images')
                          .child(imageName)
                          .getDownloadURL(),
                      builder: (context, snapshot) {
                        return Image(
                          image: snapshot.data != null
                              ? NetworkImage(snapshot.data.toString())
                              : const AssetImage('images/welcome_banner.png')
                                  as ImageProvider,
                          height: 150,
                        );
                      },
                    ),
                    trailing: TextButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) => AddToCart(
                                  itemName: itemName,
                                  price: price,
                                  itemsLeft: quantity.toString(),
                                  docID: docID,
                                  karinderyaName: karinderyaName,
                                  userDetails: userDetails,
                                ));
                      },
                      child: const Icon(
                        Icons.add_circle,
                        color: kPrimaryColor,
                      ),
                    ),
                    title: Text(itemName),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          child: Text(
                            'by $karinderyaName',
                            style: const TextStyle(
                              decoration: TextDecoration.underline,
                            ),
                          ),
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) => ViewKarinderyaDialog(
                                  karinderyaName: karinderyaName,
                                  userDetails: userDetails),
                            );
                          },
                        ),
                        Text(description),
                        Text('Php $price per serving, $quantity serving left'),
                      ],
                    ),
                    isThreeLine: true,
                  ),
                ),
              ),
            ),
          );
        }

        return ListView(
          children: itemViews,
        );
      },
    );
  }
}
