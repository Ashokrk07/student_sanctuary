import 'package:flutter/material.dart';
import 'main.dart'; // Assuming this contains the main app entry point
import 'login.dart'; // Assuming this contains the login page
import 'home.dart'; // Assuming this contains the home page

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/home',
      routes: {
        '/home': (context) => HomePage(),
        '/profile': (context) => HomePageMain(),
        '/login': (context) => LoginPage(), // Example login page route
        '/logout': (context) => LogoutPage(), // Logout page route
      },
    );
  }
}

class LogoutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Show the logout confirmation dialog as soon as the LogoutPage is loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showLogoutDialog(context);
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('Logout Page'),
      ),
      body: Center(
        child: Text(
          'Redirecting...',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Logout Confirmation'),
          content: Text('Are you sure you want to logout?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                Navigator.pop(context); // Navigate back to the previous page
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/home',
                    (route) =>
                        false); // Navigate to the main page and remove all previous routes
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }
}
