import 'package:flutter/material.dart';
import 'package:koicaresystem/routes/waterstatus.dart';
import 'login.dart'; // Nhớ nhập khẩu file login.dart
import 'home.dart'; // Adjust the import as needed
import 'routes/koifish.dart'; // Import your koifish page
import 'routes/pond.dart'; // Import your pond page
//import 'routes/shop.dart'; // Import your shop page

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
      initialRoute: '/login', // Start at the home route
      routes: {
        '/login': (context) => LoginPage(), // Trang đăng nhập
        '/home': (context) => HomePage(), // Trang chính
        '/koifish': (context) => KoiFishPage(), // KoiFish page
        '/pond': (context) => PondPage(), // Pond page
        '/shop': (context) => HomePage(), // Shop page
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(builder: (context) => LoginPage()); // Fallback route
      }, // Trang khởi đầu là trang đăng nhập
      debugShowCheckedModeBanner: false, // Tắt tag debug
    );
  }
}
