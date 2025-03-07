import 'package:education_app/constants/color.dart';
import 'package:education_app/constants/icons.dart';
import 'package:education_app/constants/size.dart';
import 'package:education_app/screens/featuerd_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BaseScreen extends StatefulWidget {
  const BaseScreen({Key? key}) : super(key: key);
  static const routeName = "BaseScreen";


  @override
  _BaseScreenState createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  int _selectedIndex = 0;
  String _token = ""; // Store token


  static const List<Widget> _widgetOptions = <Widget>[
    FeaturedScreen(),
    FeaturedScreen(),
    FeaturedScreen(),
    FeaturedScreen(),
  ];
  @override

  void initState() {
    super.initState();
    _loadToken(); // Load token when screen initializes
  }

  Future<void> _loadToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _token = prefs.getString('token') ?? "No Token Found";
    });

    print("Stored Token: $_token"); // Print token in console
  }


  // child: Text(
  // "Token: $_token",
  // style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
  // textAlign: TextAlign.center,
  // ),


  
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          selectedItemColor: kPrimaryColor,
          backgroundColor: Colors.white,
          elevation: 0,
          items: [
            BottomNavigationBarItem(
              activeIcon: Image.asset(
                icFeatured,
                height: kBottomNavigationBarItemSize,
              ),
              icon: Image.asset(
                icFeaturedOutlined,
                height: kBottomNavigationBarItemSize,
              ),
              label: "Featured",
            ),
            BottomNavigationBarItem(
              activeIcon: Image.asset(
                icLearning,
                height: kBottomNavigationBarItemSize,
              ),
              icon: Image.asset(
                icLearningOutlined,
                height: kBottomNavigationBarItemSize,
              ),
              label: "My Learning",
            ),
            BottomNavigationBarItem(
              activeIcon: Image.asset(
                icWishlist,
                height: kBottomNavigationBarItemSize,
              ),
              icon: Image.asset(
                icWishlistOutlined,
                height: kBottomNavigationBarItemSize,
              ),
              label: "Wishlist",
            ),
            BottomNavigationBarItem(
              activeIcon: Image.asset(
                icSetting,
                height: kBottomNavigationBarItemSize,
              ),
              icon: Image.asset(
                icSettingOutlined,
                height: kBottomNavigationBarItemSize,
              ),
              label: "Settings",
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: (int index) {
            setState(() {
              _selectedIndex = index;
            });
          }),
    );
  }
}
