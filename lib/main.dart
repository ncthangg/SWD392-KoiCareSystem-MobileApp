import 'package:flutter/material.dart';
import 'login.dart'; // Nhớ nhập khẩu file login.dart
import 'home.dart'; // Adjust the import as needed

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Koi Care System',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/', // Start at the home route
      routes: {
        '/': (context) => HomePage(), // Home route
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(builder: (context) => HomePage()); // Fallback route
      }, // Trang khởi đầu là trang đăng nhập
    );
  }
}
