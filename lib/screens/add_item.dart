import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:karinderya_system/models/store_data.dart';
import 'package:karinderya_system/models/user_details.dart';
import 'dart:io';
import '../constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddItem extends StatefulWidget {
  @override
  State<AddItem> createState() => _AddItemState();

  final UserDetails userDetails;
  AddItem({required this.userDetails});
}

class _AddItemState extends State<AddItem> {
  bool fieldsError = false;
  String foodName = '';
  String price = '';
  String quantity = '';
  String imageName = '';
  String description = '';
  File? file;
  FirebaseFirestore? _firestore;
  FirebaseStorage? _firebaseStorage;
  User? _user;

  @override
  void initState() {
    super.initState();
    _firestore = FirebaseFirestore.instance;
    _firebaseStorage = FirebaseStorage.instance;
    _user = FirebaseAuth.instance.currentUser;
  }

  Future<void> uploadItem(
      String foodName, String quantity, String price, String imageName) async {
    await _firestore!.collection('live_items').add({
      'karinderya_name': widget.userDetails.name,
      'food_name': foodName,
      'price': price,
      'quantity': quantity,
      'image_name': imageName,
      'description': description,
    });
  }

  Future<void> uploadImage(File file) async {
    await _firebaseStorage!.ref('/food_images').child(imageName).putFile(file);
  }

  @override
  Widget build(BuildContext context) {
    final textController = TextEditingController();
    return Container(
      height: 800,
      color: Color(0xFF757575),
      child: Container(
        child: Padding(
          padding: const EdgeInsets.only(top: 30, left: 30, right: 30),
          child: Column(
            children: [
              fieldsError
                  ? const Text('Fill all required fields first!',
                      style: TextStyle(color: Colors.red))
                  : const SizedBox(height: 0),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        const Text(
                          'Food name',
                          style: kAddItemTextStyle,
                        ),
                        TextField(
                          onChanged: (newText) {
                            foodName = newText;
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      children: [
                        const Text(
                          'Price',
                          style: kAddItemTextStyle,
                        ),
                        TextField(
                          keyboardType: TextInputType.number,
                          onChanged: (newVal) {
                            price = newVal;
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        const Text(
                          'Quantity',
                          style: kAddItemTextStyle,
                        ),
                        TextField(
                          keyboardType: TextInputType.number,
                          onChanged: (newVal) {
                            quantity = newVal;
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text('Description'),
              TextField(
                maxLines: null,
                maxLength: 100,
                style: const TextStyle(
                  color: Colors.black54,
                  fontSize: 14,
                ),
                onChanged: (newText) {
                  description = newText;
                },
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  const Text(
                    'Image',
                    style: kAddItemTextStyle,
                  ),
                  GestureDetector(
                    onTap: () async {
                      FilePickerResult? result = await FilePicker.platform
                          .pickFiles(type: FileType.image);
                      if (result != null) {
                        imageName =
                            DateTime.now().millisecondsSinceEpoch.toString();
                        setState(() {
                          file = File(result.files.single.path!);
                        });
                      }
                    },
                    child: Material(
                      elevation: 5,
                      child: Container(
                        child: const Padding(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            'Select Image',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        color: kPrimaryColor,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        file = null;
                      });
                    },
                    child: const Material(
                      elevation: 5,
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          'Remove',
                          style: TextStyle(color: kPrimaryColor),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 5),
                  child: Image(
                      image: file != null
                          ? FileImage(file!)
                          : const AssetImage(
                              'images/welcome_banner.png',
                            ) as ImageProvider),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  try {
                    setState(() {
                      fieldsError = false;
                    });
                    if (foodName.isNotEmpty &&
                        price.isNotEmpty &&
                        quantity.isNotEmpty &&
                        file != null) {
                      await uploadItem(foodName, quantity, price, imageName);
                      await uploadImage(file!);

                      Navigator.pop(context);
                    } else {
                      setState(() {
                        fieldsError = true;
                      });
                    }
                  } catch (e) {
                    Navigator.pop(context);
                    print(e);
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
                },
                child: Material(
                  color: kPrimaryColor,
                  borderRadius: const BorderRadius.all(Radius.circular(30)),
                  elevation: 5,
                  child: Container(
                    width: double.infinity,
                    child: const Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        'Display Item',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 17,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20),
            topLeft: Radius.circular(20),
          ),
        ),
      ),
    );
  }
}
