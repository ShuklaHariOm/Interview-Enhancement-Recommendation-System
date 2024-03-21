import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter_mini_project/LoginPage.dart';

void main() {
  runApp(
    DevicePreview(
      enabled: true,
      builder: (context) => MyApp(),
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
        colorScheme:
            ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 207, 236, 250)),
        useMaterial3: true,
      ),
      // home: const MyHomePage(title: 'InterviewPro'),
      debugShowCheckedModeBanner: false,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      routes: {
        '/': (context) => const CustomScaffold(
              child: LoginForm(), // No need to pass title here
            ),
        // '/home' : (context) => MyHomePage(),
        // '/signup': (context) => SignupPage(),
      },
    );
  }
}

class CustomScaffold extends StatelessWidget {
  final Widget child;

  const CustomScaffold({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('InterviewPro'),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image
          Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/background.png'),
                    fit: BoxFit.cover)),
          ),
          // Child content
          Positioned.fill(child: child),
        ],
      ),
    );
  }
}
