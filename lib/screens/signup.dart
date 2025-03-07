import 'package:flutter/material.dart';

class SignUpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Sign Up Now!", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            _buildTextField(Icons.person, "Full Name"),
            _buildTextField(Icons.email, "Email"),
            _buildTextField(Icons.lock, "Password", isPassword: true),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {}, // تنفيذ إنشاء الحساب
              child: Text("Sign Up"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // الرجوع لصفحة تسجيل الدخول
              },
              child: Text("Already have an account? Log in"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(IconData icon, String hint, {bool isPassword = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: TextField(
        obscureText: isPassword,
        decoration: InputDecoration(
          prefixIcon: Icon(icon),
          hintText: hint,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }
}
