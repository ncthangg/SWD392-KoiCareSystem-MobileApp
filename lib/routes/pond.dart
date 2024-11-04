import 'package:flutter/material.dart';
import 'package:koicaresystem/routes/waterstatus.dart';
import 'package:koicaresystem/services/pondService.dart';
import '../helper/apiService.dart';

class PondPage extends StatefulWidget {
  @override
  _PondPageState createState() => _PondPageState();
}

class _PondPageState extends State<PondPage> {
  final ApiService _apiService = ApiService();
  final PondService _pondService = PondService();
  List<Map<String, dynamic>> _pondList = [];
  bool _isAdmin = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchPondFish();
  }

  Future<void> _fetchPondFish() async {
    setState(() {
      _isLoading = true;
    });

    try {
      _isAdmin = await _apiService.checkUserRole();
      final userInfo = await _apiService.getUserInfo();
      if (_isAdmin) {
        _pondList = List<Map<String, dynamic>>.from(await _pondService.getAllPond());
      } else {
        int? userId = userInfo['userId'] as int?;
        if (userId != null) {
          var ponds = await _pondService.getPondByUserId(userId);
          _pondList = List<Map<String, dynamic>>.from(ponds);
        } else {
          print("User ID is null.");
        }
      }
    } catch (error) {
      print("Error fetching pond data: $error");
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
        title: Text("Pond"),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _pondList.isEmpty
          ? Center(child: Text("No Pond found."))
          : ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: _pondList.length,
        itemBuilder: (context, index) {
          final pond = _pondList[index];
          return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WaterStatusPage(pond: pond), // Chuyển sang trang WaterStatusPage
                  ),
                );
              },
          child: Card(
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Hiển thị hình ảnh từ thư mục tài sản
                Image.asset(
                  'lib${pond['imageUrl']}', // Sử dụng đường dẫn tương đối
                  //'lib/images/ponds/7d4bcd71-e606-45de-aa49-68a97e270ed3_ho1.jpg',
                  height: 300, // Chiều cao hình ảnh
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
                        pond['pondName'] ?? 'Unknown',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(height: 8),
                      // Kích thước hồ
                      Text(
                        "Size: ${pond['size']} m²",
                        style: TextStyle(color: Colors.grey),
                      ),
                      Text(
                        "Depth: ${pond['depth']} m²",
                        style: TextStyle(color: Colors.grey),
                      ),
                      Text(
                        "Volume: ${pond['volume']} m²",
                        style: TextStyle(color: Colors.grey),
                      ),
                      Text(
                        "DrainCount: ${pond['drainCount']} m²",
                        style: TextStyle(color: Colors.grey),
                      ),
                      Text(
                        "PumpCapacity: ${pond['pumpCapacity']} m²",
                        style: TextStyle(color: Colors.grey),
                      ),
                      Text(
                        "SkimmerCount: ${pond['skimmerCount']} m²",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ));
        },
      ),
    );
  }
}
