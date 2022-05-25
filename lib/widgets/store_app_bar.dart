import 'package:flutter/material.dart';
import 'package:karinderya_system/models/store_data.dart';
import 'package:provider/provider.dart';
import '../screens/login.dart';

class StoreAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsets.only(right: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(Provider.of<StoreData>(context).user.email!),
            GestureDetector(
              child: const Text('Logout'),
              onTap: () async {
                await Provider.of<StoreData>(context, listen: false).logOut();
                Navigator.pushNamed(context, Login.id);
              },
            )
          ],
        ),
      ),
      width: double.infinity,
      color: Colors.white,
      height: 50,
    );
  }
}
