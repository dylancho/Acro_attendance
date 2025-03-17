import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'qr_screen.dart'; // Regular user QR code screen
import 'admin_home.dart'; // Admin panel

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

  void loginUser() async {
    setState(() => isLoading = true); // Show loading state

    try {
      if (isAdminLogin) {
        // Admin login with Firebase Authentication
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        // Navigate to Admin Panel
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AdminHomeScreen()),
        );
      } else {
        // Regular member login (Anonymous)
        if (_nameController.text.isEmpty) {
          setState(() => isLoading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Please enter your name!")),
          );
          return;
        }

        UserCredential userCredential =
            await FirebaseAuth.instance.signInAnonymously();
        String userId = userCredential.user!.uid;

        // Navigate to QR Screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                QRScreen(userId: userId, userName: _nameController.text),
          ),
        );
      }
    } catch (e) {
      print("Login Failed: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Login Failed: ${e.toString()}")),
      );
    } finally {
      setState(() => isLoading = false); // Hide loading state
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SwitchListTile(
              title: Text("Admin Login"),
              value: isAdminLogin,
              onChanged: (value) {
                setState(() {
                  isAdminLogin = value;
                });
              },
            ),
            if (isAdminLogin) ...[
              TextField(
                controller: _emailController,
                decoration: InputDecoration(labelText: "Admin Email"),
                keyboardType: TextInputType.emailAddress,
              ),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: "Admin Password"),
                obscureText: true,
              ),
            ] else ...[
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: "Enter Your Name"),
              ),
            ],
            SizedBox(height: 20),
            isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: loginUser,
                    child: Text("Login"),
                  ),
          ],
        ),
      ),
    );
  }
}
