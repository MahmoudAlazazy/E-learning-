import 'package:flutter/material.dart';
import 'package:education_app/screens/base_screen.dart';
import 'package:education_app/screens/signup.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:audioplayers/audioplayers.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = "login";

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isObscured = true;
  bool _isLoading = false;
  String _errorMessage = "";
  final AudioPlayer _audioPlayer = AudioPlayer(); // Audio Player Instance

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
      _errorMessage = "";
    });

    try {
      final response = await http.post(
        Uri.parse('https://apis.mohamedelenany.com/public/api/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': _emailController.text,
          'password': _passwordController.text,
        }),
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', responseData['token']);
        await prefs.setString('user', json.encode(responseData['user']));
        // Save login timestamp
        await prefs.setInt('login_time', DateTime.now().millisecondsSinceEpoch);
        bool isFirstLogin = prefs.getBool('first_login') ?? true; // Check if first login
        if (isFirstLogin) {
          await _playLoginSound(); // Play sound only for first login
          await prefs.setBool('first_login', false); // Set first login to false
        }
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => BaseScreen()),
        );
      } else {
        setState(() {
          _errorMessage = responseData['message'] ?? 'فشل تسجيل الدخول. حاول مرة أخرى.';
        });
      }
    } catch (error) {
      setState(() {
        _errorMessage = 'حدث خطأ. تحقق من اتصالك بالإنترنت.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _playLoginSound() async {
    await _audioPlayer.play(AssetSource("sounds/login_sound.mp3"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Background color to match the image
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 80), // Space from top
            Text(
              "تسجيل الدخول",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "سجل الدخول عبر الطرق التالية",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.white70),
            ),
            SizedBox(height: 30),

            Divider(color: Colors.white24), // Separator line
            SizedBox(height: 15),

            _buildTextField("البريد الإلكتروني أو رقم المحمول", controller: _emailController),
            _buildTextField("كلمة المرور", isPassword: true, controller: _passwordController),

            // Align(
            //   alignment: Alignment.centerRight,
            //   child: TextButton(
            //     onPressed: () {
            //       // Forgot password logic
            //     },
            //     child: Text("نسيت كلمة المرور؟", style: TextStyle(color: Colors.white, fontSize: 14)),
            //   ),
            // ),

            SizedBox(height: 10),
// Show error message if there is one
            if (_errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  _errorMessage,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.red, fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),

            ElevatedButton(
              onPressed: _isLoading ? null : _login,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber[700], // Golden yellow color
                padding: EdgeInsets.symmetric(vertical: 14, horizontal: 100),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), // Matching the image button style
                ),
              ),
              child: _isLoading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text(
                "تسجيل الدخول",
                style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),

            Spacer(),

            Divider(color: Colors.white24),
            SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("ليس لديك حساب؟ ", style: TextStyle(color: Colors.white, fontSize: 14)),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpScreen()));
                  },
                  child: Text("اشترك الآن", style: TextStyle(color: Colors.amber[700], fontSize: 14, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String hint, {bool isPassword = false, required TextEditingController controller}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextField(
        textAlign: TextAlign.right, // Align text for Arabic layout
        controller: controller,
        obscureText: isPassword ? _isObscured : false,
        style: TextStyle(color: Colors.white, fontSize: 16),
        decoration: InputDecoration(
          suffixIcon: isPassword
              ? IconButton(
            icon: Icon(_isObscured ? Icons.visibility_off : Icons.visibility, color: Colors.white),
            onPressed: () {
              setState(() {
                _isObscured = !_isObscured;
              });
            },
          )
              : null,
          hintText: hint,
          hintStyle: TextStyle(color: Colors.white54, fontSize: 16),
          filled: true,
          fillColor: Colors.black, // Dark input field background
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.amber[700]!, width: 2), // Matching golden yellow border
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.white38, width: 1.5), // Subtle white border
          ),
        ),
      ),
    );
  }
}
