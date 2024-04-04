import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:device_preview/device_preview.dart';
import 'package:flutter_mini_project/LoginPage.dart';
import 'package:flutter_mini_project/SignupPage.dart';
import 'package:flutter_mini_project/home.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import SharedPreferences

void main() {
  runApp(
    DevicePreview(
      enabled: true,
      builder: (context) => const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 207, 236, 250)),
        useMaterial3: true,
      ),
      // home: const MyHomePage(title: 'InterviewPro'),
      debugShowCheckedModeBanner: false,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      initialRoute: 'login',
      routes: {
        'login': (context) => LoginPage(),
        'home': (context) => FutureBuilder(
              future: checkLoginStatus(),
              builder: (context, AsyncSnapshot<bool> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Scaffold(
                      body: Center(child: CircularProgressIndicator()));
                } else {
                  if (snapshot.hasData && snapshot.data!) {
                    return const Home();
                  } else {
                    // User is not logged in, redirect to login page
                    WidgetsBinding.instance!.addPostFrameCallback((_) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Please Login'),
                            content:
                                Text('You need to log in to access this page.'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  Navigator.pushReplacementNamed(
                                      context, 'login');
                                },
                                child: Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                    });
                    return SizedBox();
                  }
                }
              },
            ),
        'signup': (context) => SignupPage(),
      },
    );
  }

  Future<bool> checkLoginStatus() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token =
          prefs.getString('token'); // Retrieve token from SharedPreferences
      print('Token: $token');
      final response = await http.get(
        Uri.parse('http://127.0.0.1:5000/check_login'),
        headers: {
          'Authorization':
              'Bearer $token', // Include token in the request headers
        },
      );
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        final bool isLoggedIn = responseData['logged_in'];
        print('Login status: $responseData');
        return isLoggedIn;
      } else {
        // Handle server error
        print('Server error: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      // Handle network or other errors
      print('Error: $e');
      return false;
    }
  }
}

// class CustomScaffold extends StatelessWidget {
//   final Widget child;

//   const CustomScaffold({Key? key, required this.child}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//         title: Text('InterviewPro'),
//       ),
//       body: Stack(
//         fit: StackFit.expand,
//         children: [
//           // Background image
//           Container(
//             decoration: BoxDecoration(
//                 image: DecorationImage(
//                     image: AssetImage('assets/background.png'),
//                     fit: BoxFit.cover)),
//           ),
//           // Child content
//           Positioned.fill(child: child),
//         ],
//       ),
//     );
//   }
// }
