import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:karinderya_system/constants.dart';
import 'package:karinderya_system/models/user_details.dart';

import 'package:timeago/timeago.dart' as timeago;

class CustomerHistory extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final UserDetails userDetails;
  CustomerHistory({required this.userDetails});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('orders')
          .where('customer', isEqualTo: userDetails.name)
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: ((context, snapshot) {
        if (snapshot.hasData) {
          var results = snapshot.data!.docs;
          List<ListTile> orders = [];

          for (var order in results) {
            var itemName = order.get('item_name');
            var karinderyaName = order.get('karinderya');
            var totalPrice = order.get('total_price');
            Icon leadingIcon = Icon(Icons.done);
            var quantity = order.get('quantity');

            if (order.get('status') == 'pending') {
              leadingIcon = const Icon(
                Icons.pending,
                color: kPrimaryColor,
              );
            } else if (order.get('status') == 'approved') {
              leadingIcon = Icon(
                Icons.delivery_dining,
                color: Colors.blue[600],
              );
            } else if (order.get('status') == 'denied') {
              leadingIcon = Icon(
                Icons.error_outline,
                color: Colors.red[600],
              );
            } else if (order.get('status') == 'delivered') {
              leadingIcon = Icon(
                Icons.done,
                color: Colors.green[600],
              );
            }

            orders.add(ListTile(
              isThreeLine: true,
              leading: leadingIcon,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '$itemName',
                    style: const TextStyle(
                        color: kPrimaryColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 17),
                  ),
                  Text(
                    timeago.format(DateTime.now().subtract(Duration(
                        milliseconds: DateTime.now().millisecondsSinceEpoch -
                            int.parse(order.get('timestamp').toString())))),
                    style: const TextStyle(
                      color: Colors.black45,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              subtitle: Column(
                children: [
                  Text('from $karinderyaName'),
                  Text('Quantity : $quantity, Total : Php $totalPrice'),
                ],
                crossAxisAlignment: CrossAxisAlignment.start,
              ),
            ));
          }

          return ListView(
            children: orders,
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }
      }),
    );
  }
}
