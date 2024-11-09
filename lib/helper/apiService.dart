import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';

final _storage = FlutterSecureStorage();

class ApiService {
   String? email;
   String? role;
   int? userId;

  Future<void> fetchData() async {
    final token = await _storage.read(key: "auth_token");

    final response = await http.get(
      Uri.parse("http://10.0.2.2:5000/authenticate"),
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

  Future<String> getToken() async {
    final token = await _storage.read(key: "auth_token");
    return token ?? "";
  }

  Future<bool> checkUserRole() async {
    final token = await getToken();
    if (token.isNotEmpty) {
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      String role = decodedToken["r"] ?? 'role is null';
    return role == 'Admin';
    }
    return false;
  }

   Future<Map<String, dynamic>> getUserInfo() async {
     email = await _storage.read(key: "email") ?? '';
     userId = int.tryParse(await _storage.read(key: "userId") ?? '') ?? -1;
     role = await _storage.read(key: "role") ?? '';

     return {
       'email': email,
       'userId': userId,
       'role': role,
     };
   }
  // Function to initialize user session data from token
   Future<void> initializeFromToken() async {
    final token = await _storage.read(key: "auth_token");
    if (token != null) {
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      email = decodedToken["e"];
      final idClaim = decodedToken["id"];
      userId = idClaim != null ? int.tryParse(idClaim) : null;
      role = decodedToken["r"];

      await _storage.write(key: "email", value: email);
      await _storage.write(key: "userId", value: userId.toString());
      await _storage.write(key: "role", value: role);
    }
  }
}
