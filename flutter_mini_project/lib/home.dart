import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future<void> _logout() async {
    try {
      final response = await http.post(
        Uri.parse('http://127.0.0.1:5000/logout'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        // Logout successful
        // Navigate to login screen or show a message
        Navigator.pushNamed(context, 'login');
      } else {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final String errorMessage = responseData['error'];
        // Handle error message
      }
    } catch (e) {
      // Handle network or server errors
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/background.png'), fit: BoxFit.cover)),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Home Page'),
          actions: [
            IconButton(
              onPressed: _logout,
              icon: Icon(Icons.logout),
            ),
          ],
        ),
        backgroundColor: Colors.transparent,
        body: Center(child: Text('Welcome')),
      ),
    );
  }
}
