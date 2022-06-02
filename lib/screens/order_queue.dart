import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:karinderya_system/models/user_details.dart';

import '../constants.dart';
import '../models/item.dart';
import '../widgets/OrderTile.dart';

class OrderQueue extends StatelessWidget {
  final UserDetails userDetails;
  OrderQueue({required this.userDetails});
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('orders')
            .where('karinderya', isEqualTo: userDetails.name)
            .orderBy('status', descending: true)
            .snapshots(),
        builder: (context, snapshots) {
          if (snapshots.hasData) {
            var orders = snapshots.data!.docs;

            List<OrderTile> ordersView = [];
            for (var order in orders) {
              var itemName = order.get('item_name').toString();
              var customer = order.get('customer').toString();
              var price = order.get('total_price').toString();
              var quantity = order.get('quantity').toString();
              var status = order.get('status').toString();
              var timestamp = order.get('timestamp').toString();

              ordersView.add(
                OrderTile(
                  timestamp: timestamp,
                  customer: customer,
                  price: price,
                  itemName: itemName,
                  quantity: quantity,
                  status: status,
                  docID: order.id,
                ),
              );
            }
            ordersView.sort((a, b) {
              return b.timestamp.compareTo(a.timestamp);
            });

            ordersView.removeWhere((order) =>
                order.status == 'delivered' || order.status == 'denied');

            return Expanded(
              child: ListView(
                children: ordersView,
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.lightBlueAccent,
              ),
            );
          }
        });
  }
}
