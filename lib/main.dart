import 'package:flutter/material.dart';
import 'package:karinderya_system/screens/register.dart';
import 'package:karinderya_system/screens/store_screen.dart';
import 'package:karinderya_system/screens/welcome_screen.dart';
import './constants.dart';
import './screens/login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
        child: Login(),
      ),
      routes: {
        Login.id: (context) => Login(),
        Register.id: (context) => Register(),
        WelcomScreen.id: (context) => WelcomScreen(),
      },
      theme: ThemeData().copyWith(
          colorScheme: ColorScheme.light().copyWith(
            primary: const Color(0xff1d2030),
          ),
          scaffoldBackgroundColor: kPrimaryColor,
          backgroundColor: kPrimaryColor,
          bottomSheetTheme: BottomSheetThemeData()),
    );
  }
}
