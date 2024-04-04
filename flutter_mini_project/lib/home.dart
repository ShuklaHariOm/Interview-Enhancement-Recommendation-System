import 'package:flutter/material.dart';
import 'package:flutter_mini_project/TestPage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<String> subjects = [];
  List<String> selectedSubjects = []; // List to store selected subjects

  @override
  void initState() {
    super.initState();
    fetchSubjects();
  }

  Future<void> fetchSubjects() async {
    final Uri url = Uri.parse('http://127.0.0.1:5000/subjects');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      setState(() {
        subjects = json.decode(response.body).cast<String>();
      });
    } else {
      throw Exception('Failed to load subjects');
    }
  }

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

  void _toggleSelectedSubject(String subject) {
    setState(() {
      if (selectedSubjects.contains(subject)) {
        selectedSubjects.remove(subject);
      } else {
        selectedSubjects.add(subject);
      }
    });
  }

  void _submitSubjects() {
    if (selectedSubjects.isNotEmpty) {
      print('Selected Subjects: $selectedSubjects');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Interview Pro'),
        actions: [
          IconButton(
            onPressed: _logout,
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 16.0), // Add space between top and subjects
            Wrap(
              spacing: 22.0, // Gap between chips
              runSpacing: 8.0,
              children: subjects.map((subject) {
                return SizedBox(
                  height: 50.0, // Set the height of each subject selector
                  child: ChoiceChip(
                    label: Text(
                      subject,
                      style: TextStyle(fontSize: 20.0), // Increase font size
                    ),
                    selected: selectedSubjects.contains(subject),
                    onSelected: (selected) {
                      _toggleSelectedSubject(subject);
                    },
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 16.0),
        child: ElevatedButton(
          onPressed: () {
            _submitSubjects;
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TestPage()),
            );
          },
          child: const Text('Submit'),
        ),
      ),
    );
  }
}
