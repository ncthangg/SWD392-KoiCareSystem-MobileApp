import 'package:flutter/material.dart';
import 'package:koicaresystem/services/waterStatusService.dart';

class WaterStatusPage extends StatefulWidget {
  final Map<String, dynamic> pond;

  WaterStatusPage({required this.pond});

  @override
  _WaterStatusPageState createState() => _WaterStatusPageState();
}

class _WaterStatusPageState extends State<WaterStatusPage> {
  late Future<Map<String, dynamic>> _waterStatus;

  @override
  void initState() {
    super.initState();
    _waterStatus =
        WaterStatusService().getWaterStatusByPondId(widget.pond['pondId']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${widget.pond['pondName']}",
          style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
        ),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _waterStatus,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('No data available.'));
          } else {
            final waterParameter = snapshot.data!['waterParameter'];
            final status = snapshot.data!['status'];
            final evaluations = snapshot.data!['evaluations'];

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Water Parameters",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  Table(
                    border: TableBorder.all(color: Colors.grey),
                    columnWidths: const {
                      0: FlexColumnWidth(2),
                      1: FlexColumnWidth(1),
                    },
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle, // Center-aligns text vertically
                    children: [
                      _buildTableRow(
                        "Temperature",
                        "${waterParameter['temperature']} °C",
                        evaluations['Temperature'] ?? "unknown", // Pass status from evaluations
                      ),
                      _buildTableRow(
                        "Salinity",
                        "${waterParameter['salinity']} g/L",
                        evaluations['Salinity'] ?? "unknown",
                      ),
                      _buildTableRow(
                        "pH",
                        "${waterParameter['ph']}",
                        evaluations['PH'] ?? "unknown",
                      ),
                      _buildTableRow(
                        "O2",
                        "${waterParameter['o2']} mg/L",
                        evaluations['O2'] ?? "unknown",
                      ),
                      _buildTableRow(
                        "NO2",
                        "${waterParameter['no2']} mg/L",
                        evaluations['NO2'] ?? "unknown",
                      ),
                      _buildTableRow(
                        "NO3",
                        "${waterParameter['no3']} mg/L",
                        evaluations['NO3'] ?? "unknown",
                      ),
                      _buildTableRow(
                        "PO4",
                        "${waterParameter['po4']} mg/L",
                        evaluations['PO4'] ?? "unknown",
                      ),
                    ],
                  ),
                  SizedBox(height: 32),
                  Center(
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12.0),
                      margin: const EdgeInsets.symmetric(horizontal: 16.0),
                      decoration: BoxDecoration(
                        color: _getStatusColor(status), // Use helper function to get color based on status
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: Text(
                        "$status",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  TableRow _buildTableRow(String parameter, String value, String evaluation) {
    Color color;

    // Determine cell color based on the evaluation status
    switch (evaluation) {
      case "Good":
        color = Colors.green;
        break;
      case "Within acceptable range":
        color = Colors.yellowAccent;
        break;
      case "Bad":
        color = Colors.redAccent;
        break;
      default:
        color = Colors.redAccent;
    }

    return TableRow(
      children: [
        Container(
          color: color,
          padding: const EdgeInsets.symmetric(vertical: 16.0), // Increases row height
          alignment: Alignment.center,
          child: Text(
            parameter,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            textAlign: TextAlign.center,
          ),
        ),
        Container(
          color: color,
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          alignment: Alignment.center,
          child: Text(
            value,
            style: TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case "Good":
        return Colors.green;
      case "Average":
        return Colors.yellowAccent;
      case "Bad":
        return Colors.redAccent;
      default:
        return Colors.blueAccent; // Default color if status is unknown
    }
  }

}
