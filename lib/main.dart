import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:test/adminlogin.dart';
import 'package:test/collegereg.dart';
import 'dart:async';
import 'collegelogin.dart';
import 'register.dart';
import 'login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student Sanctuary App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _totalCases = 0;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _updateCaseCount();

    // Listen for changes in the problem_report collection
    _firestore.collection('problem_reports').snapshots().listen((snapshot) {
      _updateCaseCount();
    });
  }

  Future<void> _updateCaseCount() async {
    try {
      QuerySnapshot snapshot =
          await _firestore.collection('problem_reports').get();
      setState(() {
        _totalCases = snapshot.docs.length;
      });
    } catch (e) {
      print('Error fetching case count: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //  SizedBox(height: 10),
              Image.asset(
                'assets/logo.png',
                width: 300,
                height: 250,
              ),
              SizedBox(height: 10),
              Text(
                'Welcome to Student Sanctuary',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Text(
                  'This app is designed to ensure the safety of students in our college. Report any safety concerns anonymously and get support from the college and local police.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(height: 20),
              Image.asset(
                'assets/student_image.jpg', // Placeholder image for student content
                width: 300,
                height: 200,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RegistrationPage()));
                  // Navigate to student registration page
                },
                child: Text('Student Register'),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginPage()));
                  // Navigate to student login page
                },
                child: Text('Student Sign In'),
              ),

              SizedBox(height: 20.0),
              Center(
                child: ClipOval(
                  child: Container(
                    color: Colors.white,
                    height: 200.0, // Set a fixed height
                    width: 200.0, // Set a fixed width
                    child: Card(
                      color: Colors.white,
                      elevation: 7.0,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Total Cases',
                              style: TextStyle(
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 28, 23, 47),
                              ),
                            ),
                            SizedBox(height: 16.0),
                            Text(
                              '$_totalCases+',
                              style: TextStyle(
                                fontSize: 28.0,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 28, 23, 47),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 10),
              Text(
                'College Principal',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Text(
                  'The college principal is responsible for the cases that is been occuring in the college, if he don\'t take any action then the case will be transferred to police authority.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CollegeRegister()));
                  // Navigate to student registration page
                },
                child: Text('College Register'),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => CollegeLogin()));
                  // Navigate to student login page
                },
                child: Text('College Sign In'),
              ),

              SizedBox(height: 30),
              Text(
                'Police Information',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text(
                  'Our dedicated police force is committed to ensuring the safety of all students. They work diligently to investigate reported incidents and take necessary actions to maintain a secure environment.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white),
                ),
              ),

              SizedBox(height: 20),
              Image.asset(
                'assets/police_image.jpeg', // Placeholder image for police content
                width: 300,
                height: 200,
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AdminLoginPage()));
                  // Navigate to police login page
                },
                child: Text('Admin Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
