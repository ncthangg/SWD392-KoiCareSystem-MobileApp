import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'home.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
        Uri.parse('https://10.0.2.2:7237/api/koi-care-system/login'), // Thay thế bằng URL API của bạn
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

        print("Token saved: $token");
        // Xử lý kết quả thành công và điều hướng đến trang chính
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
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              child: Text('Login'),
            ),
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text(
                  _errorMessage!,
                  style: TextStyle(color: Colors.red),
                ),
              ),
          ],
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
