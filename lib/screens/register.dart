import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:karinderya_system/screens/login.dart';
import 'package:karinderya_system/screens/welcome_screen.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../constants.dart';

class Register extends StatefulWidget {
  static const String id = '/register';

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool showSpinner = false;
  String email = '';
  String password = '';
  String fullName = '';
  String userType = 'customer';
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: Column(
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 30, left: 10, bottom: 5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        child: Center(
                          child: Image.asset(
                            'images/welcome_banner.png',
                            height: 125,
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Welcome to Online Karinderya',
                            style: TextStyle(
                              color: kAccentColor,
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Signup to start',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.start,
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                color: kPrimaryColor,
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 30,
                      right: 30,
                      top: 40,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('User Type'),
                        Row(
                          children: [
                            Container(
                                child: Row(
                              children: [
                                Radio<String>(
                                    value: 'customer',
                                    groupValue: userType,
                                    onChanged: (value) {
                                      setState(() {
                                        userType = value!;
                                      });
                                    }),
                                Text('Customer')
                              ],
                            )),
                            Container(
                                child: Row(
                              children: [
                                Radio<String>(
                                    value: 'karinderya',
                                    groupValue: userType,
                                    onChanged: (value) {
                                      setState(() {
                                        userType = value!;
                                      });
                                    }),
                                Text('Karinderya')
                              ],
                            )),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Email'),
                            TextField(
                              keyboardType: TextInputType.emailAddress,
                              decoration: const InputDecoration(
                                hintText: 'user@email.com',
                              ),
                              onChanged: (newText) {
                                email = newText;
                              },
                            ),
                            const SizedBox(height: 10),
                            Text(userType == 'customer'
                                ? 'Full name'
                                : 'Karinderya name'),
                            TextField(
                              keyboardType: TextInputType.name,
                              decoration: const InputDecoration(
                                hintText: 'Juan Dela Cruz',
                              ),
                              autofocus: true,
                              onChanged: (newText) {
                                fullName = newText;
                              },
                            ),
                            const SizedBox(height: 10),
                            const Text('Password'),
                            TextField(
                              onChanged: (newText) {
                                password = newText;
                              },
                              keyboardType: TextInputType.visiblePassword,
                              obscureText: true,
                              decoration: const InputDecoration(
                                hintText: 'Password',
                              ),
                            ),
                          ],
                        ),
                        Container(
                          width: double.infinity,
                          child: Column(
                            children: [
                              TextButton(
                                onPressed: () async {
                                  setState(() {
                                    showSpinner = true;
                                  });
                                  try {
                                    var user = await _auth
                                        .createUserWithEmailAndPassword(
                                            email: email, password: password);

                                    await _firestore
                                        .collection('user_details')
                                        .add({
                                      'email': email,
                                      'user_type': userType,
                                      'name': fullName,
                                    });
                                    if (user != null) {
                                      Navigator.pushNamed(context, Login.id);
                                    }
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
                                  setState(() {
                                    showSpinner = false;
                                  });
                                },
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: kPrimaryColor,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(5),
                                    ),
                                  ),
                                  width: double.infinity,
                                  child: const Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Text(
                                      'Sign Up',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  height: 425,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
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
