import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../helper/apiService.dart';

class PondService {
  final String baseUrl = 'http://10.0.2.2:5000/pond'; // Replace with your API URL
  final FlutterSecureStorage storage = FlutterSecureStorage();
  final ApiService _apiService = ApiService();

  Future<List<dynamic>> getAllPond() async {
    final token = await _apiService.getToken();
    final response = await http.get(
      Uri.parse(baseUrl),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);

      if (responseData.containsKey('\$values')) {
        // Trả về danh sách hồ từ trường '$values'
        return List<dynamic>.from(responseData['\$values']);
      } else {
        // Nếu không có '$values', ném ra một lỗi
        throw Exception('Response does not contain \$values key');
      }
    } else {
      throw Exception('Failed to load user fish data: ${response.reasonPhrase}');
    }
  }

  Future<List<dynamic>> getPondByUserId([int? userId]) async {
    final token = await _apiService.getToken();
    Uri uri = Uri.parse(userId != null ? '$baseUrl/user/$userId' : baseUrl);

    try {
      final response = await http.get(
        uri,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        if (responseData.containsKey('\$values')) {
          // Trả về danh sách hồ từ trường '$values'
          return List<dynamic>.from(responseData['\$values']);
        } else {
          // Nếu không có '$values', ném ra một lỗi
          throw Exception('Response does not contain \$values key');
        }
      } else {
        throw Exception('Failed to load user fish data: ${response.reasonPhrase}');
      }
    } catch (error) {
      throw Exception('Error fetching pond data: $error');
    }
  }

  Future<Map<String, dynamic>> getPondById(int pondId) async {
    final token = await _apiService.getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/$pondId'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load pond details: ${response.reasonPhrase}');
    }
  }

  Future<bool> addPond(Map<String, dynamic> pondData) async {
    final token = await _apiService.getToken();
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(pondData),
    );

    if (response.statusCode == 201) {
      return true;
    } else {
      throw Exception('Failed to add pond: ${response.reasonPhrase}');
    }
  }

  Future<bool> updatePond(int pondId, Map<String, dynamic> pondData) async {
    final token = await _apiService.getToken();
    final response = await http.put(
      Uri.parse('$baseUrl/$pondId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(pondData),
    );

    if (response.statusCode == 204) {
      return true;
    } else {
      throw Exception('Failed to update pond: ${response.reasonPhrase}');
    }
  }

  Future<bool> deletePond(int pondId) async {
    final token = await _apiService.getToken();
    final response = await http.delete(
      Uri.parse('$baseUrl/$pondId'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 204) {
      return true;
    } else {
      throw Exception('Failed to delete pond: ${response.reasonPhrase}');
    }
  }
}
