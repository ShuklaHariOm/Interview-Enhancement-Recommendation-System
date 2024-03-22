import 'package:flutter/material.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/background.png'), fit: BoxFit.cover)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SignupForm(),
      ),
    );
  }
}

class SignupForm extends StatefulWidget {
  const SignupForm({super.key});

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.only(left: 35, top: 130),
          child: Text(
            'InterviewPro ',
            style:
                TextStyle(color: Color.fromARGB(255, 24, 12, 12), fontSize: 35),
          ),
        ),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
            padding: EdgeInsets.only(top: 270),
            child: Text(
              'Create Account ',
              style: TextStyle(
                  color: Color.fromARGB(255, 44, 60, 77), fontSize: 25),
            ),
          ),
        ]),
        SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.4,
                right: 35,
                left: 35),
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.center,
              // mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                      fillColor: Color.fromARGB(255, 241, 251, 251),
                      filled: true,
                      labelText: 'Email',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(
                  height: 18,
                ),
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    fillColor: Color.fromARGB(255, 241, 251, 251),
                    filled: true,
                    labelText: 'Password',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  obscureText: true,
                ),
                SizedBox(
                  height: 30,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.fromLTRB(30, 10, 30, 10)),
                  onPressed: () {},
                  child: Text(
                    'Sign Up',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, 'login');
                        },
                        child: Text('Already have an account?',
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              fontSize: 18,
                            ))),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
