import 'package:flutter/material.dart';
import 'package:education_app/screens/login.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isObscured = true;
  bool _isLoading = false;
  String _errorMessage = "";

  Future<void> _signUp() async {
    setState(() {
      _isLoading = true;
      _errorMessage = "";
    });

    try {
      final response = await http.post(
        Uri.parse('https://apis.mohamedelenany.com/public/api/register'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'name': _nameController.text,
          'email': _emailController.text,
          'password': _passwordController.text,
        }),
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', responseData['token']);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("تم إنشاء الحساب بنجاح! حسابك غير نشط حتى الاشتراك."),
            backgroundColor: Colors.orange,
          ),
        );
      } else {
        setState(() {
          _errorMessage = responseData['message'] ?? 'فشل إنشاء الحساب. حاول مرة أخرى.';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Black background like the login screen
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 80), // Space from top
            Text(
              "إنشاء حساب جديد",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "أدخل التفاصيل لإنشاء حسابك",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.white70),
            ),
            SizedBox(height: 30),

            Divider(color: Colors.white24), // Separator line
            SizedBox(height: 15),

            _buildTextField("الاسم الكامل", controller: _nameController),
            _buildTextField("البريد الإلكتروني", controller: _emailController),
            _buildTextField("كلمة المرور", isPassword: true, controller: _passwordController),

            SizedBox(height: 15),

            if (_errorMessage.isNotEmpty)
              Text(
                _errorMessage,
                style: TextStyle(color: Colors.red, fontSize: 14),
              ),

            SizedBox(height: 20),

            ElevatedButton(
              onPressed: _isLoading ? null : _signUp,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber[700], // Golden yellow color
                padding: EdgeInsets.symmetric(vertical: 14, horizontal: 100),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), // Matching the button style
                ),
              ),
              child: _isLoading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text(
                "إنشاء الحساب",
                style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),

            Spacer(),

            Divider(color: Colors.white24),
            SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("لديك حساب بالفعل؟ ", style: TextStyle(color: Colors.white, fontSize: 14)),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                  },
                  child: Text("تسجيل الدخول", style: TextStyle(color: Colors.amber[700], fontSize: 14, fontWeight: FontWeight.bold)),
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
