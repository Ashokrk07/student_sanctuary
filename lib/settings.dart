import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Color.fromARGB(255, 28, 23, 47), // Static theme color
      ),
      home: SettingsPage(),
    );
  }
}

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings', style: TextStyle(color: Colors.white)),
        backgroundColor: Color.fromARGB(255, 28, 23, 47),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text(
              'Languages',
              style: TextStyle(color: Color.fromARGB(255, 28, 23, 47)),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: Color.fromARGB(255, 28, 23, 47),
            ),
            onTap: () {
              // Navigate to Languages page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LanguagesPage()),
              );
            },
          ),
          ListTile(
            title: Text(
              'App Info',
              style: TextStyle(color: Color.fromARGB(255, 28, 23, 47)),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: Color.fromARGB(255, 28, 23, 47),
            ),
            onTap: () {
              // Navigate to App Info page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AppInfoPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}

class LanguagesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Languages', style: TextStyle(color: Colors.white)),
        backgroundColor: Color.fromARGB(255, 28, 23, 47),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Text(
          'Languages Settings',
          style: TextStyle(
            color: Color.fromARGB(255, 28, 23, 47),
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}

class AppInfoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('App Info', style: TextStyle(color: Colors.white)),
        backgroundColor: Color.fromARGB(255, 28, 23, 47),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Text(
          'App Info Details',
          style: TextStyle(
            color: Color.fromARGB(255, 28, 23, 47),
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
