import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class OrderTile extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String itemName;
  String customer;
  String price;
  String quantity;
  String status;
  String timestamp;
  String docID;

  OrderTile({
    required this.itemName,
    required this.customer,
    required this.price,
    required this.quantity,
    required this.status,
    required this.timestamp,
    required this.docID,
  });

  @override
  Widget build(BuildContext context) {
    Icon leadingIcon = Icon(Icons.done);
    if (status == 'pending') {
      leadingIcon = const Icon(
        Icons.pending,
        color: kPrimaryColor,
      );
    } else if (status == 'approved') {
      leadingIcon = Icon(
        Icons.delivery_dining,
        color: Colors.blue[600],
      );
    } else if (status == 'denied') {
      leadingIcon = Icon(
        Icons.error_outline,
        color: Colors.red[600],
      );
    } else if (status == 'delivered') {
      leadingIcon = Icon(
        Icons.done,
        color: Colors.green[600],
      );
    }
    return ListTile(
      leading: leadingIcon,
      title: Text(itemName),
      isThreeLine: true,
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Ordered by : $customer'),
          Text('Quantity : $quantity, Price : Php $price'),
          Text('Status: $status'),
          status == 'pending'
              ? Row(
                  children: [
                    TextButton(
                      onPressed: () async {
                        await _firestore
                            .collection('orders')
                            .doc(docID)
                            .update({'status': 'approved'});
                      },
                      child: const Material(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        elevation: 5,
                        color: kPrimaryColor,
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            'Proceed',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        await _firestore
                            .collection('orders')
                            .doc(docID)
                            .update({'status': 'denied'});
                      },
                      child: const Material(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        elevation: 5,
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            'Cancel',
                            style: TextStyle(color: kPrimaryColor),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : TextButton(
                  onPressed: () async {
                    await _firestore
                        .collection('orders')
                        .doc(docID)
                        .update({'status': 'delivered'});
                  },
                  child: const Material(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    elevation: 5,
                    color: Colors.green,
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        'Mark as done',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
