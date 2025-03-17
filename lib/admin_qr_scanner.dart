import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:firebase_database/firebase_database.dart';

class AdminQRScanner extends StatefulWidget {
  @override
  _AdminQRScannerState createState() => _AdminQRScannerState();
}

class _AdminQRScannerState extends State<AdminQRScanner> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  String scannedData = "";

  void handleScannedData(String qrData) {
    List<String> parts = qrData.split('|');
    String userId = parts[0];
    int timestamp = int.parse(parts[1]);

    DatabaseReference ref = FirebaseDatabase.instance
        .ref("attendance_records/${DateTime.now().toString().split(' ')[0]}");

    ref.child(userId).set({"status": "출석", "timestamp": timestamp}).then((_) {
      print("출석 처리 완료!");
    }).catchError((error) {
      print("출석 처리 실패: $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("QR 출석 스캔")),
      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: QRView(
              key: qrKey,
              onQRViewCreated: (QRViewController controller) {
                this.controller = controller;
                controller.scannedDataStream.listen((scanData) {
                  handleScannedData(scanData.code ?? "");
                });
              },
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(child: Text("QR코드 데이터: $scannedData")),
          ),
        ],
      ),
    );
  }
}
