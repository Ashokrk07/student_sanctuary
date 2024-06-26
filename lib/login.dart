import 'package:flutter/material.dart';
import 'register.dart';
import 'forgotpassword.dart';
import 'home.dart';

class LoginPage extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // Define the primary color to be used for AppBar, Card, and Button
    final primaryColor = Color.fromARGB(255, 28, 23, 47);
    // Define white color for contrast text
    final contrastColor = Colors.white;

    return Scaffold(
      appBar: AppBar(
        title: Text('Login',
            style: TextStyle(color: contrastColor)), // Text in white
        backgroundColor: primaryColor,
        iconTheme: IconThemeData(color: contrastColor), // AppBar color
      ),
      body: Stack(
        children: [
          // Background color removed
          Center(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Card(
                    elevation: 5.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    color: primaryColor, // Card color
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize
                              .min, // Ensures the Card is not taller than necessary
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Email',
                                labelStyle: TextStyle(
                                    color: contrastColor), // Label in white
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color:
                                          contrastColor), // Underline in white
                                ),
                              ),
                              style: TextStyle(
                                  color: contrastColor), // Input text in white
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your email';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 20.0),
                            TextFormField(
                              obscureText: true,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                labelStyle: TextStyle(
                                    color: contrastColor), // Label in white
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color:
                                          contrastColor), // Underline in white
                                ),
                              ),
                              style: TextStyle(
                                  color: contrastColor), // Input text in white
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your password';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 20.0),
                            ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              HomePageMain())); // All fields are valid, proceed with login
                                  // Add your login logic here
                                }
                              },
                              child: Text('Login',
                                  style: TextStyle(
                                      color:
                                          primaryColor)), // Button text in white
                              style: ElevatedButton.styleFrom(
                                backgroundColor: contrastColor, // Button color
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                              ),
                            ),
                            SizedBox(height: 10.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    // Navigate to the registration page
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              RegistrationPage()),
                                    );
                                  },
                                  child: Text(
                                    'Don\'t have an account? Register',
                                    style: TextStyle(
                                      color: Colors.blue,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10.0),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ForgotPasswordPage()),
                                ); // Implement Forgot Password functionality
                              },
                              child: Text(
                                'Forgot Password?',
                                style: TextStyle(
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: EdgeInsets.all(20.0), // Padding to separate from edges
              child: Image.asset(
                'assets/hii.jpg', // Path to your local image
                width: 150, // Set the width of the image
                height: 150, // Set the height of the image
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: LoginPage(),
  ));
}
