import 'package:flutter/material.dart';
import 'helper/apiservice.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final apiService = ApiService();
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                // Navigate to the homepage logic without showing back button
                Navigator.pushReplacementNamed(context, '/'); // Adjust route to match defined routes
              },
              child: Row(
                children: [
                  Icon(Icons.home, color: Colors.white),
                  SizedBox(width: 8),
                  Text('Koi Care System', style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                _showUserMenu(context); // Show options on tap
              },
              child: Icon(Icons.person, color: Colors.white), // Thay email bằng icon người dùng
            ),
          ],
        ),
        backgroundColor: Colors.lightBlueAccent, // Màu nền của AppBar
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 350,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.blue,
                    Colors.lightBlueAccent,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Opacity(
                      opacity: 0.6,
                      child: Image.asset(
                        'lib/assets/images/background/background1.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Welcome to Koi Care System',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Chăm sóc và theo dõi sức khỏe cá Koi tại nhà',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.count(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(), // Prevent scrolling
                crossAxisCount: 2, // Number of cards in a row
                mainAxisSpacing: 16.0, // Space between rows
                crossAxisSpacing: 16.0, // Space between columns
                children: [
                  _buildCard(
                    context,
                    'Quản lý Cá Koi',
                    'lib/assets/images/using/fish.jpg',
                    '/Member/KoiFishPages/Index',
                  ),
                  _buildCard(
                    context,
                    'Quản lý Hồ',
                    'lib/assets/images/using/pond.jpg',
                    '/Member/WaterParameters/Detail',
                  ),
                  _buildCard(
                    context,
                    'Cửa Hàng',
                    'lib/assets/images/using/store.jpg',
                    '/Member/Shop/Main',
                  ),
                  // Add more cards if needed
                ],
              ),
            ),
            SizedBox(height: 20),
            Divider(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Các Bài Viết Hữu Ích',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            _buildArticleCard(
              context,
              'Hướng dẫn chăm sóc cá Koi',
              'Những bước cơ bản để bắt đầu chăm sóc cá Koi tại nhà.',
              'lib/assets/images/using/phattrien.jpg',
              '/Blog/Guide',
            ),
            _buildArticleCard(
              context,
              'Cách duy trì chất lượng nước trong hồ',
              'Lời khuyên về cách giữ nước sạch và ổn định cho cá Koi.',
              'lib/assets/images/using/water.jpg',
              '/Blog/WaterQuality',
            ),
            _buildArticleCard(
              context,
              'Dinh dưỡng cho cá Koi',
              'Các loại thức ăn và chế độ dinh dưỡng phù hợp cho cá Koi.',
              'lib/assets/images/using/nutrition.jpg',
              '/Blog/Nutrition',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, String title, String imagePath, String route) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, route);
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // Rounded corners
        ),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(10)), // Rounded top corners
              child: Image.asset(
                imagePath,
                height: 120,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildArticleCard(BuildContext context, String title, String description, String imagePath, String route) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, route);
      },
      child: Card(
        elevation: 2,
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.asset(imagePath, height: 100, width: 100, fit: BoxFit.cover),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 4),
                    Text(description),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showUserMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.info),
                title: Text('Xem thông tin người dùng'),
                onTap: () {
                  // Logic to view user info
                  Navigator.pop(context); // Đóng menu sau khi chọn
                },
              ),
              ListTile(
                leading: Icon(Icons.logout),
                title: Text('Đăng xuất'),
                onTap: () {
                  // Logic to log out
                  Navigator.pop(context); // Đóng menu sau khi chọn
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
