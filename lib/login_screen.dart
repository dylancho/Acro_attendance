import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'admin_home.dart'; // Admin page
import 'package:firebase_database/firebase_database.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isAdminLogin = false;
  bool isLoading = false;

  void submitAttendance() async {
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("이름을 입력해주세요!")),
      );
      return;
    }

    setState(() => isLoading = true);

    String userName = _nameController.text.trim();
    int timestamp = DateTime.now().millisecondsSinceEpoch;

    DatabaseReference ref = FirebaseDatabase.instance
        .ref("attendance_records/${DateTime.now().toString().split(' ')[0]}");

    await ref.push().set({"name": userName, "timestamp": timestamp}).then((_) {
      setState(() => isLoading = false);

      // Show confirmation popup
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("출석 완료"),
          content: Text("$userName님, 출석되었습니다!"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close popup
                _nameController.clear(); // Clear name input
              },
              child: Text("확인"),
            )
          ],
        ),
      );
    }).catchError((error) {
      print("출석 저장 실패: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("출석 저장 실패: $error")),
      );
      setState(() => isLoading = false);
    });
  }

  void loginAsAdmin() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("이메일과 비밀번호를 입력하세요!")),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Navigate to Admin Home
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AdminHomeScreen()),
      );
    } catch (e) {
      print("Admin Login Failed: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("로그인 실패: ${e.toString()}")),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("출석 체크")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 일반 사용자 입력 필드
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: "이름을 입력하세요"),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: submitAttendance,
              child: Text("출석하기"),
            ),

            Divider(height: 40), // 구분선 추가

            // 관리자 로그인 필드
            Text("관리자 로그인", style: TextStyle(fontWeight: FontWeight.bold)),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: "관리자 이메일"),
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: "관리자 비밀번호"),
              obscureText: true,
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: loginAsAdmin,
              child: Text("관리자 로그인"),
            ),
          ],
        ),
      ),
    );
  }
}
