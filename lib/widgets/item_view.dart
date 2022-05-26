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
                      }),
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
                          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore.',
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 13,
                          ),
                        ),
                        SizedBox(height: 5),
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
                            const Icon(
                              Icons.edit_note,
                              size: 30,
                              color: kPrimaryColor,
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
