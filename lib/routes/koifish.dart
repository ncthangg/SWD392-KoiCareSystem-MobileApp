import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:koicaresystem/routes/waterstatus.dart';
import 'package:koicaresystem/services/fishService.dart';
import '../helper/apiService.dart';
import '../services/pondService.dart';

class KoiFishPage extends StatefulWidget {
  @override
  _KoiFishPageState createState() => _KoiFishPageState();
}

class _KoiFishPageState extends State<KoiFishPage> {
  final ApiService _apiService = ApiService();
  final FishService _fishService = FishService();
  final PondService _pondService = PondService();
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
      _isAdmin = await _apiService.checkUserRole();
      final userInfo = await _apiService.getUserInfo();

      if (_isAdmin) {
        _koiFishList = List<Map<String, dynamic>>.from(await _fishService.getAllFish());
      } else {
        int? userId = userInfo['userId'] as int?;
        if (userId != null) {
          var koiFish = await _fishService.getFishByUserId(userId);
          _koiFishList = List<Map<String, dynamic>>.from(koiFish);
        } else {
          print("User ID is null.");
        }
      }

      for (var koi in _koiFishList) {
        if (koi['pondId'] != null) {
          final pond = await _pondService.getPondById(koi['pondId']);
          koi['pondName'] = pond['pondName']; // Assign pond name
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
          final creationDate = koiFish['createdAt'] != null
              ? DateFormat('yyyy-MM-dd').format(DateTime.parse(koiFish['createdAt']))
              : 'Unknown Date';
          return Card(
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  'lib${koiFish['imageUrl']}',
                  height: 300,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(Icons.error, size: 40);
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            koiFish['fishName'] ?? 'Unknown',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          Text(
                            creationDate,
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text("Age: ${koiFish['age']} y-o", style: TextStyle(color: Colors.grey)),
                      Text("BodyShape: ${koiFish['bodyShape']} m²", style: TextStyle(color: Colors.grey)),
                      Text("Size: ${koiFish['size']} m²", style: TextStyle(color: Colors.grey)),
                      Text("Weight: ${koiFish['weight']} kg", style: TextStyle(color: Colors.grey)),
                      Text("Gender: ${koiFish['gender']} ", style: TextStyle(color: Colors.grey)),
                      Text("Origin: ${koiFish['origin']} ", style: TextStyle(color: Colors.grey)),
                      Text("Price: ${koiFish['price']}.đ", style: TextStyle(color: Colors.grey)),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => WaterStatusPage(pond: {
                                    'pondId': koiFish['pondId'],
                                    'pondName': koiFish['pondName'],
                                  }),
                                ),
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                              decoration: BoxDecoration(
                                color: Colors.blue[50], // Light background color for the button
                                borderRadius: BorderRadius.circular(20.0), // Rounded corners
                                border: Border.all(color: Colors.blue), // Border color
                              ),
                              child: Text(
                                koiFish['pondName'] ?? 'Unknown Pond',
                                style: TextStyle(
                                  color: Colors.blue[800], // Text color to contrast with background
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
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



