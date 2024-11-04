import 'package:flutter/material.dart';
import 'package:koicaresystem/services/fishService.dart';

import '../helper/apiService.dart';


class KoiFishPage extends StatefulWidget {
  @override
  _KoiFishPageState createState() => _KoiFishPageState();
}

class _KoiFishPageState extends State<KoiFishPage> {
  final ApiService _apiService = ApiService();
  final FishService _fishService = FishService();
  List<Map<String, dynamic>> _koiFishList = [];
  bool _isAdmin = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchKoiFish();
  }

  Future<void> _fetchKoiFish() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Check user's role
      _isAdmin = await _apiService.checkUserRole();
      final userInfo = await _apiService.getUserInfo();
      // Fetch koi fish based on role
      if (_isAdmin) {
        _koiFishList = List<Map<String, dynamic>>.from(await _fishService.getAllFish());
      } else {
        int? userId = userInfo['userId'] as int?; // Extract userId from the map
        if (userId != null) {
          var koiFish = await _fishService.getFishByUserId(userId);
          _koiFishList = List<Map<String, dynamic>>.from(koiFish);
        } else {
          print("User ID is null.");
        }
      }
    } catch (error) {
      print("Error fetching koi fish data: $error");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Koi Fishes"),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _koiFishList.isEmpty
          ? Center(child: Text("No Fishes found."))
          : ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: _koiFishList.length,
        itemBuilder: (context, index) {
          final koiFish = _koiFishList[index];

          return Card(
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Hiển thị hình ảnh từ thư mục tài sản
                Image.asset(
                  'lib${koiFish['imageUrl']}', // Sử dụng đường dẫn tương đối
                  //'lib/images/ponds/7d4bcd71-e606-45de-aa49-68a97e270ed3_ho1.jpg',
                  height: 150, // Chiều cao hình ảnh
                  fit: BoxFit.cover,
                  width: double.infinity, // Chiếm toàn bộ chiều rộng
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(Icons.error, size: 40);
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Tên hồ
                      Text(
                        koiFish['fishName'] ?? 'Unknown',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(height: 8),
                      // Kích thước hồ
                      Text(
                        "Age: ${koiFish['age']} y-o",
                        style: TextStyle(color: Colors.grey),
                      ),
                      Text(
                        "BodyShape: ${koiFish['bodyShape']} m²",
                        style: TextStyle(color: Colors.grey),
                      ),
                      Text(
                        "Size: ${koiFish['size']} m²",
                        style: TextStyle(color: Colors.grey),
                      ),
                      Text(
                        "Weight: ${koiFish['weight']} kg",
                        style: TextStyle(color: Colors.grey),
                      ),
                      Text(
                        "Gender: ${koiFish['gender']} ",
                        style: TextStyle(color: Colors.grey),
                      ),
                      Text(
                        "Origin: ${koiFish['origin']} ",
                        style: TextStyle(color: Colors.grey),
                      ),
                      Text(
                        "Price: ${koiFish['price']}.đ",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}