import 'package:flutter/material.dart';

// class LoginPage extends StatefulWidget {
//   const LoginPage({super.key});

//   // final String title;

//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       // decoration: BoxDecoration(
//       //     image: DecorationImage(
//       //         image: AssetImage('assets/background.png'), fit: BoxFit.cover)),
//       child: Scaffold(
//         // appBar: AppBar(
//         //   backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//         //   // title: Text(widget.title),
//         // ),
//         body: LoginForm(),
//         backgroundColor: Colors.transparent,
//       ),
//     );
//   }
// }

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(50.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 300,
            child: TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
          ),
          SizedBox(height: 20),
          Container(
            width: 300,
            child: TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
              onPressed: () {
                //implment login funcionality
              },
              child: Text('Login'))
        ],
      ),
    );
  }
}
