import 'package:bookapp/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool isLogin = true;
  bool isLoading = false; // To show loading state

  void _submit() async {
    try {
      setState(() {
        isLoading = true; // Show loading indicator
      });

      if (isLogin) {
        await _auth.signInWithEmailAndPassword(
            email: _email.text, password: _password.text);
      } else {
        await _auth.createUserWithEmailAndPassword(
            email: _email.text, password: _password.text);
      }

      // On success, navigate to home page or the next screen
       Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomePage()));

    } catch (e) {
      print(e);
      setState(() {
        isLoading = false; // Hide loading indicator
      });

      // Display error message
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text(e.toString()), // Show error message from Firebase
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isLogin ? 'Login' : 'Register')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _email,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _password,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: isLoading ? null : _submit, // Disable button while loading
              child: isLoading
                  ? CircularProgressIndicator() // Show loading spinner
                  : Text(isLogin ? 'Login' : 'Register'),
            ),
            TextButton(
              onPressed: () {
                setState(() => isLogin = !isLogin);
              },
              child: Text(isLogin
                  ? 'Create an account'
                  : 'Already have an account?'),
            ),
          ],
        ),
      ),
    );
  }
}
