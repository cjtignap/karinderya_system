import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:karinderya_system/screens/welcome_screen.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
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
  FirebaseAuth? _auth;
  @override
  void initState() {
    super.initState();
    _auth = FirebaseAuth.instance;
  }

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
                      top: 45,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Full Name'),
                            TextField(
                              keyboardType: TextInputType.name,
                              decoration: const InputDecoration(
                                hintText: 'Juan Dela Cruz',
                              ),
                              autofocus: true,
                              onChanged: (newText) {},
                            ),
                            const SizedBox(height: 15),
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
                                    var user = await _auth!
                                        .createUserWithEmailAndPassword(
                                            email: email, password: password);
                                    if (user != null) {
                                      Navigator.pushNamed(
                                          context, WelcomScreen.id);
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
                                    color: kAccentColor,
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
