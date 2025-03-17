import 'package:flutter/material.dart';
import 'admin_qr_scanner.dart';
import 'attendance_list.dart';

class AdminHomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Admin Panel")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AdminQRScanner()),
                );
              },
              child: Text("Open QR Scanner"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AttendanceListScreen()),
                );
              },
              child: Text("View Attendance Records"),
            ),
          ],
        ),
      ),
    );
  }
}
