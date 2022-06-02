import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:karinderya_system/constants.dart';
import 'package:karinderya_system/models/item.dart';
import 'package:karinderya_system/models/user_details.dart';

class AddToCart extends StatefulWidget {
  final String itemName;
  final String price;
  final String itemsLeft;
  final String docID;
  final String karinderyaName;
  final UserDetails userDetails;
  AddToCart({
    required this.itemName,
    required this.price,
    required this.itemsLeft,
    required this.docID,
    required this.karinderyaName,
    required this.userDetails,
  });

  @override
  State<AddToCart> createState() => _AddToCartState();
}

class _AddToCartState extends State<AddToCart> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  int _quantity = 0;
  bool error = false;
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Add to cart',
                style: TextStyle(
                    color: kPrimaryColor,
                    fontSize: 17,
                    fontWeight: FontWeight.w400),
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                widget.itemName,
                style: const TextStyle(
                    color: kPrimaryColor,
                    fontSize: 20,
                    fontWeight: FontWeight.w500),
              ),
              Text(
                'Php ${widget.price}',
                style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 14,
                    fontWeight: FontWeight.w400),
              ),
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Quantity : ',
                      style: TextStyle(
                          color: kPrimaryColor,
                          fontSize: 15,
                          fontWeight: FontWeight.w400),
                    ),
                    flex: 1,
                  ),
                  Expanded(
                    flex: 3,
                    child: TextField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: '${widget.itemsLeft} servings left',
                      ),
                      onChanged: (newVal) {
                        setState(() {
                          if (newVal.isNotEmpty) {
                            if (int.parse(newVal) >
                                int.parse(widget.itemsLeft)) {
                              error = true;
                            } else {
                              error = false;
                            }
                            _quantity = int.parse(newVal);
                          } else {
                            _quantity = 0;
                          }
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Text('Total : Php ${_quantity * double.parse(widget.price)}'),
              const SizedBox(
                height: 10,
              ),
              error
                  ? const Text(
                      'Not enough items left',
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: 15,
                          fontWeight: FontWeight.w500),
                    )
                  : const SizedBox(
                      height: 0,
                    ),
              TextButton(
                onPressed: () async {
                  if (!error) {
                    try {
                      await _firestore
                          .collection('live_items')
                          .doc(widget.docID)
                          .update({
                        'quantity': int.parse(widget.itemsLeft) - _quantity
                      });

                      await _firestore.collection('orders').add({
                        'karinderya': widget.karinderyaName,
                        'quantity': _quantity,
                        'customer': widget.userDetails.name,
                        'status': 'pending',
                        'total_price': _quantity * double.parse(widget.price),
                        'item_name': widget.itemName,
                        'item_id': widget.docID,
                        'timestamp': DateTime.now().millisecondsSinceEpoch,
                      });

                      if (int.parse(widget.itemsLeft) - _quantity <= 0) {
                        await _firestore
                            .collection('live_items')
                            .doc(widget.docID)
                            .delete();
                      }

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: (const Text('Order placed sucess')),
                          action: SnackBarAction(
                              label: 'Hide',
                              onPressed: () {
                                ScaffoldMessenger.of(context)
                                    .hideCurrentSnackBar();
                              }),
                        ),
                      );
                      Navigator.pop(context);
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: (Text(e.toString())),
                          action: SnackBarAction(
                              label: 'Hide',
                              onPressed: () {
                                ScaffoldMessenger.of(context)
                                    .hideCurrentSnackBar();
                              }),
                        ),
                      );
                    }
                  }
                },
                child: Material(
                  color: error ? Colors.black38 : kPrimaryColor,
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                  elevation: 5,
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Place Order',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
