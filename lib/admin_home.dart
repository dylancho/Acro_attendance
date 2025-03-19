import 'package:flutter/material.dart';
import 'attendance_list.dart';

class AdminHomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("관리자 페이지")),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AttendanceListScreen()),
            );
          },
          child: Text("출석 기록 보기"),
        ),
      ),
    );
  }
}
