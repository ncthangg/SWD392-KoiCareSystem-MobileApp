import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final _storage = FlutterSecureStorage();

  Future<void> fetchData() async {
    final token = await _storage.read(key: "auth_token");

    final response = await http.get(
      Uri.parse("http://10.0.2.2:7237/api/koi-care-system/secure-endpoint"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      print("Data fetched successfully!");
    } else {
      print("Failed to fetch data: ${response.body}");
    }
  }
}
