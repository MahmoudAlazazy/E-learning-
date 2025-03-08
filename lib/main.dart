import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:education_app/screens/base_screen.dart';
import 'package:education_app/screens/login.dart';
import 'package:education_app/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensures SharedPreferences works properly
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Widget? _initialScreen;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    int? loginTime = prefs.getInt('login_time');
    int sessionDuration = 30 * 60 * 1000; // 30 minutes in milliseconds

    if (token != null && loginTime != null) {
      int currentTime = DateTime.now().millisecondsSinceEpoch;
      if (currentTime - loginTime > sessionDuration) {
        // Session expired, clear data and go to login
        await prefs.clear();
        setState(() {
          _initialScreen = LoginScreen();
        });
      } else {
        // Session is still valid, go to home screen
        setState(() {
          _initialScreen = BaseScreen();
        });
      }
    } else {
      // No token, go to login screen
      setState(() {
        _initialScreen = LoginScreen();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mr.Mohamed Elanany',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Poppins',
      ),
      home: _initialScreen ?? SplashScreen(), // Show splash until check completes
    );
  }
}
