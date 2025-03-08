import 'dart:async';
import 'package:education_app/screens/login.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  static const String routeName = "routeName";

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(  // Ensures full-screen coverage
        child: Image.asset(
          'assets/icons/splash.jpg',
          fit: BoxFit.cover,  // Ensures the image covers the screen
        ),
      ),
    );
  }
}
