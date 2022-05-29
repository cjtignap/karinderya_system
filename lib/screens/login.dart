import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:karinderya_system/models/user_details.dart';
import 'package:karinderya_system/screens/customer_screen.dart';
import 'package:karinderya_system/screens/store_screen.dart';
import 'package:karinderya_system/screens/welcome_screen.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import '../constants.dart';
import './register.dart';

class Login extends StatefulWidget {
  static const String id = '/login';

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool showSpinner = false;
  String email = '';
  String password = '';
  FirebaseAuth? _auth;
  FirebaseFirestore? _firestore;
  User? user;
  @override
  void initState() {
    super.initState();
    initFirebase();
  }

  void initFirebase() async {
    await Firebase.initializeApp();
    _auth = FirebaseAuth.instance;
    _firestore = FirebaseFirestore.instance;

    var snapshot = await _firestore!
        .collection('user_details')
        .where('email', isEqualTo: _auth!.currentUser!.email)
        .get();
    var result = snapshot.docs.first;
    if (_auth!.currentUser != null) {
      if (result.get('user_type') == 'karinderya') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: ((context) {
              return StoreScreen(
                user: _auth!.currentUser!,
                auth: _auth!,
                userDetails: UserDetails(
                  name: result.get('name'),
                  userType: result.get('user_type'),
                ),
              );
            }),
          ),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: ((context) {
              return CustomerScreen(
                userDetails: UserDetails(
                  name: result.get('name'),
                  userType: result.get('user_type'),
                ),
              );
            }),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                          'Login to use the app',
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
                    top: 45,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Email'),
                          TextField(
                            onChanged: (newText) {
                              email = newText;
                            },
                            autofocus: true,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              hintText: 'user@email.com',
                            ),
                          ),
                          const SizedBox(height: 15),
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
                          const SizedBox(height: 15),
                          Container(
                            width: double.infinity,
                            child: const Text(
                              'Forgot Password?',
                              textAlign: TextAlign.end,
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
                                try {
                                  setState(() {
                                    showSpinner = true;
                                  });
                                  var user =
                                      await _auth!.signInWithEmailAndPassword(
                                    email: email,
                                    password: password,
                                  );
                                  if (user != null) {
                                    var snapshot = await _firestore!
                                        .collection('user_details')
                                        .where('email',
                                            isEqualTo: user.user!.email)
                                        .get();
                                    var result = snapshot.docs.first;
                                    if (result.get('user_type') ==
                                        'karinderya') {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => StoreScreen(
                                            user: user.user!,
                                            auth: _auth!,
                                            userDetails: UserDetails(
                                              name: result.get('name'),
                                              userType: result.get('user_type'),
                                            ),
                                          ),
                                        ),
                                      );
                                    } else {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: ((context) {
                                            return CustomerScreen(
                                              userDetails: UserDetails(
                                                name: result.get('name'),
                                                userType:
                                                    result.get('user_type'),
                                              ),
                                            );
                                          }),
                                        ),
                                      );
                                    }
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
                                    'Login',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pushNamed(context, Register.id);
                              },
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Colors.white,
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
                                      color: kPrimaryColor,
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
    );
  }
}
