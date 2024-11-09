import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'home.dart';
import '../helper/apiService.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final ApiService _apiService = ApiService();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _storage = FlutterSecureStorage();
  String? _errorMessage;

  Future<void> _login() async {
    HttpOverrides.global = MyHttpOverrides();

    try {
      // Chấp nhận tất cả các chứng chỉ SSL
      HttpOverrides.global = MyHttpOverrides();

      final response = await http.post(
        Uri.parse('http://10.0.2.2:5000/authenticate/login'), // Thay thế bằng URL API của bạn
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': _emailController.text,
          'password': _passwordController.text,
        }),
      );
      if (response.statusCode == 200) {
        // Lấy JWT từ phản hồi
        final responseData = jsonDecode(response.body);
        final token = responseData['data']['emailVerificationToken'];

        // Lưu token vào Secure Storage
        await _storage.write(key: "auth_token", value: token);
        await _apiService.initializeFromToken();

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      } else {
        // Xử lý thông báo lỗi
        final responseData = json.decode(response.body);
        setState(() {
          _errorMessage = responseData['message'];
        });
      }
      // Xử lý phản hồi
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF73F1FF), Color(0xFF73F1FF)],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              // Image positioned at the top of the form
              Image.asset(
                'lib/images/icons/icon.png', // Corrected file path
                height: 200, // Image height
                width: 200, // Set a specific width to keep the image smaller
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(Icons.error, size: 40);
                },
              ),
              const SizedBox(height: 20),
              // Login form container
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20), // Reduced vertical padding
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.8,
                  maxHeight: MediaQuery.of(context).size.height * 0.6, // Adjusted height constraint to make it shorter
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromRGBO(27, 146, 225, 0.3),
                      blurRadius: 20,
                      offset: Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text(
                      "Login",
                      style: TextStyle(color: Colors.black, fontSize: 40),
                    ),
                    const SizedBox(height: 10), // Reduced spacing
                    TextField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        hintText: "Email",
                        hintStyle: TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10), // Reduced spacing
                    TextField(
                      controller: _passwordController,
                      decoration: const InputDecoration(
                        hintText: "Password",
                        hintStyle: TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(),
                      ),
                      obscureText: true,
                    ),
                    const SizedBox(height: 10), // Reduced spacing
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
                          // Handle "Forget Password" functionality
                        },
                        child: const Text(
                          "Forget Password?",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20), // Reduced spacing
                    Container(
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.lightBlue,
                      ),
                      child: GestureDetector(
                        onTap: _login,
                        child: const Center(
                          child: Text(
                            "Login",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


}
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
