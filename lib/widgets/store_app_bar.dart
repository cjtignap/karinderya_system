import 'package:flutter/material.dart';
import 'package:karinderya_system/constants.dart';
import 'package:karinderya_system/models/store_data.dart';
import 'package:provider/provider.dart';
import '../screens/login.dart';

class StoreAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5,
      child: Container(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ProfileDropdown(),
            ],
          ),
        ),
        width: double.infinity,
        color: kPrimaryColor,
      ),
    );
  }
}

class ProfileDropdown extends StatefulWidget {
  @override
  State<ProfileDropdown> createState() => _ProfileDropdownState();
}

class _ProfileDropdownState extends State<ProfileDropdown> {
  String currentItem = 'profile';

  List<DropdownMenuItem<String>> dropdownItems = [
    DropdownMenuItem(
      child:
          ContextItem(image: AssetImage('images/bojji.png'), text: 'Profile'),
      value: 'profile',
    ),
    DropdownMenuItem(
      child:
          ContextItem(image: AssetImage('images/history.jpg'), text: 'History'),
      value: 'history',
    ),
    DropdownMenuItem(
      child:
          ContextItem(image: AssetImage('images/logout.png'), text: 'Logout'),
      value: 'logout',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        items: dropdownItems,
        onChanged: (contextItem) {
          setState(() async {
            currentItem = contextItem!;

            if (contextItem == 'logout') {
              await Provider.of<StoreData>(context, listen: false).logOut();
              Navigator.pushNamed(context, Login.id);
            }
          });
        },
        dropdownColor: kPrimaryColor,
        value: currentItem,
      ),
    );
  }
}

class ContextItem extends StatelessWidget {
  final ImageProvider image;
  final String text;

  ContextItem({required this.image, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 10),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: kPrimaryColor,
            backgroundImage: image,
            radius: 15,
          ),
          const SizedBox(
            width: 5,
          ),
          Text(
            text,
            style: TextStyle(color: Colors.white),
          ),
        ],
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      ),
    );
  }
}
