import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../helper/apiService.dart';

class WaterStatusService {
  final String baseUrl = 'http://10.0.2.2:5000/waterstatus'; // Sửa lại URL cho đúng
  final FlutterSecureStorage storage = FlutterSecureStorage();
  final ApiService _apiService = ApiService();

  Future<Map<String, dynamic>> getWaterStatusByPondId(int pondId) async {
    final token = await _apiService.getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/$pondId'), // Sử dụng $pondId trong URL
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);

      if (responseData.containsKey('waterParameter')) {
        return responseData;
      } else {
        throw Exception('WaterParameter data not found in the response');
      }
    } else {
      throw Exception('Failed to load water status data: ${response.reasonPhrase}');
    }
  }
}

// Future<List<dynamic>> getPondByUserId([int? userId]) async {
  //   final token = await _apiService.getToken();
  //   Uri uri = Uri.parse(userId != null ? '$baseUrl/user/$userId' : baseUrl);
  //
  //   try {
  //     final response = await http.get(
  //       uri,
  //       headers: {'Authorization': 'Bearer $token'},
  //     );
  //
  //     if (response.statusCode == 200) {
  //       // In ra nội dung response.body
  //       print('Response Body: ${response.body}');
  //       final responseData = jsonDecode(response.body);
  //
  //       if (responseData.containsKey('\$values')) {
  //         // Trả về danh sách hồ từ trường '$values'
  //         return List<dynamic>.from(responseData['\$values']);
  //       } else {
  //         // Nếu không có '$values', ném ra một lỗi
  //         throw Exception('Response does not contain \$values key');
  //       }
  //     } else {
  //       print('Response Status: ${response.statusCode}');
  //       print('Response Body: ${response.body}');
  //       throw Exception(
  //           'Failed to load user fish data: ${response.reasonPhrase}');
  //     }
  //   } catch (error) {
  //     print('Error: $error');
  //     throw Exception('Error fetching pond data: $error');
  //   }
  // }
