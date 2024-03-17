import 'package:flutter/material.dart';
// import 'package:form_field_validator/form_field_validator.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Form Field Validator Example'),
        ),
        body: FormFieldValidatorForm(),
      ),
    );
  }
}

class FormFieldValidatorForm extends StatefulWidget {
  @override
  _FormFieldValidatorFormState createState() => _FormFieldValidatorFormState();
}

class _FormFieldValidatorFormState extends State<FormFieldValidatorForm> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Email',
              ),
              validator: MultiValidator([
                RequiredValidator(errorText: 'Email is required'),
                EmailValidator(errorText: 'Enter a valid email'),
              ]),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
              ),
              validator: RequiredValidator(errorText: 'Password is required'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // Form is valid, perform your logic here
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Form is valid!'),
                    ),
                  );
                }
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
