import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class AttendanceListScreen extends StatefulWidget {
  @override
  _AttendanceListScreenState createState() => _AttendanceListScreenState();
}

class _AttendanceListScreenState extends State<AttendanceListScreen> {
  final DatabaseReference ref =
      FirebaseDatabase.instance.ref("attendance_records");
  Map<String, dynamic> attendanceData = {};

  @override
  void initState() {
    super.initState();
    fetchAttendanceData();
  }

  void fetchAttendanceData() {
    ref.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data != null) {
        setState(() {
          attendanceData = Map<String, dynamic>.from(data);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Attendance Records")),
      body: ListView(
        children: attendanceData.entries.map((entry) {
          String date = entry.key;
          Map users = entry.value;
          return ExpansionTile(
            title: Text("📅 $date"),
            children: users.entries.map<Widget>((userEntry) {
              String userId = userEntry.key;
              Map userData = userEntry.value;
              return ListTile(
                title: Text("👤 User: $userId"),
                subtitle: Text("📌 Status: ${userData['status']}"),
              );
            }).toList(),
          );
        }).toList(),
      ),
    );
  }
}
