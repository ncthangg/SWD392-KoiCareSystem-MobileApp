import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../helper/apiService.dart';

class FishService {
  final String baseUrl = 'http://10.0.2.2:5000/koifish'; // Replace with your API URL
  final FlutterSecureStorage storage = FlutterSecureStorage();
  final ApiService _apiService = ApiService();

  Future<List<dynamic>> getAllFish() async {
    final token = await _apiService.getToken();
    final response = await http.get(
      Uri.parse(baseUrl),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      // In ra nội dung response.body
      print('Response Body: ${response.body}');
      final responseData = jsonDecode(response.body);

      if (responseData.containsKey('\$values')) {
        // Trả về danh sách hồ từ trường '$values'
        return List<dynamic>.from(responseData['\$values']);
      } else {
        // Nếu không có '$values', ném ra một lỗi
        throw Exception('Response does not contain \$values key');
      }
    } else {
      print('Response Status: ${response.statusCode}');
      print('Response Body: ${response.body}');
      throw Exception('Failed to load user fish data: ${response.reasonPhrase}');
    }
  }

  Future<List<dynamic>> getFishByUserId([int? userId]) async {
    final token = await _apiService.getToken();
    Uri uri = Uri.parse(userId != null ? '$baseUrl/user/$userId' : baseUrl);

    try {
      final response = await http.get(
        uri,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        // In ra nội dung response.body
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

  Future<bool> addFish(Map<String, dynamic> fishData) async {
    final token = await _apiService.getToken();
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(fishData),
    );

    if (response.statusCode == 201) {
      return true;
    } else {
      throw Exception('Failed to add fish: ${response.reasonPhrase}');
    }
  }

  Future<bool> updateFish(int fishId, Map<String, dynamic> fishData) async {
    final token = await _apiService.getToken();
    final response = await http.put(
      Uri.parse('$baseUrl/$fishId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(fishData),
    );

    if (response.statusCode == 204) {
      return true;
    } else {
      throw Exception('Failed to update fish: ${response.reasonPhrase}');
    }
  }

  Future<bool> deleteFish(int fishId) async {
    final token = await _apiService.getToken();
    final response = await http.delete(
      Uri.parse('$baseUrl/$fishId'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 204) {
      return true;
    } else {
      throw Exception('Failed to delete fish: ${response.reasonPhrase}');
    }
  }
}