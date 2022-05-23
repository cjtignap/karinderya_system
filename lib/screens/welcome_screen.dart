import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:karinderya_system/screens/login.dart';

class WelcomScreen extends StatefulWidget {
  const WelcomScreen({Key? key}) : super(key: key);
  static const String id = '/welcome_screen';
  @override
  State<WelcomScreen> createState() => _WelcomScreenState();
}

class _WelcomScreenState extends State<WelcomScreen> {
  User? currentUser;
  FirebaseAuth? _auth;
  @override
  void initState() {
    super.initState();
    _auth = FirebaseAuth.instance;
    currentUser = _auth!.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Container(
              child: Padding(
                padding: EdgeInsets.only(right: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      child: const Text('Logout'),
                      onTap: () async {
                        await _auth!.signOut();
                        Navigator.pushNamed(context, Login.id);
                      },
                    )
                  ],
                ),
              ),
              width: double.infinity,
              color: Colors.white,
              height: 50,
            ),
            Container(
              color: Colors.white,
              child: Text('Welcome ${currentUser!.email}'),
            ),
          ],
        ),
      ),
    );
  }
}
