import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRScreen extends StatelessWidget {
  final String userId;
  final String userName;

  QRScreen({required this.userId, required this.userName});

  @override
  Widget build(BuildContext context) {
    String qrData = "$userId|${DateTime.now().millisecondsSinceEpoch}";

    return Scaffold(
      appBar: AppBar(title: Text("Your QR Code")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            QrImageView(
              data: qrData,
              version: QrVersions.auto,
              size: 200.0,
            ),
            SizedBox(height: 20),
            Text("Show this to the admin to check in."),
          ],
        ),
      ),
    );
  }
}
