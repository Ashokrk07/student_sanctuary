import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'collegecases.dart';
import 'collegetotal.dart';
import 'problemreport.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student Sanctuary',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CollegeHome(),
    );
  }
}

class CollegeHome extends StatefulWidget {
  @override
  _CollegeHomeState createState() => _CollegeHomeState();
}

class _CollegeHomeState extends State<CollegeHome> {
  int totalCases = 0;
  int collegeCases = 0;
  String collegeName = 'Loading...';

  @override
  void initState() {
    super.initState();
    _fetchCollegeName();
  }

  Future<void> _fetchCollegeName() async {
    try {
      // Ensure the user is logged in
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentSnapshot snapshot = await FirebaseFirestore.instance
            .collection('college')
            .doc(user.uid) // Use the actual user UID
            .get();
        setState(() {
          collegeName = snapshot['college_name'] ?? 'Unknown College';
        });
        _fetchCaseCounts();
      } else {
        setState(() {
          collegeName = 'User not logged in';
        });
      }
    } catch (e) {
      setState(() {
        collegeName = 'Error fetching college name';
      });
    }
  }

  Future<void> _fetchCaseCounts() async {
    try {
      // Fetch total number of cases
      QuerySnapshot totalCasesSnapshot =
          await FirebaseFirestore.instance.collection('problem_reports').get();
      setState(() {
        totalCases = totalCasesSnapshot.docs.length;
      });

      // Fetch number of cases for the specific college
      QuerySnapshot collegeCasesSnapshot = await FirebaseFirestore.instance
          .collection('problem_reports')
          .where('college', isEqualTo: collegeName.toLowerCase())
          .get();
      setState(() {
        collegeCases = collegeCasesSnapshot.docs.length;
      });
    } catch (e) {
      print('Error fetching case counts: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Home Page',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(255, 28, 23, 47), // Updated color
        iconTheme: IconThemeData(color: Colors.white),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage(
                      'assets/avatar.jpeg'), // Replace with your avatar image path
                  radius: 30,
                ),
                SizedBox(width: 10),
                Text(
                  collegeName,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'The college is actively working on ensuring the safety and security of all students. We encourage students to report any issues they face, and we promise to address them promptly and effectively. Here are some of the initiatives we are taking to protect our students:',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CollegeTotalCases(),
                        ),
                      );
                    },
                    child: Card(
                      color: Color.fromARGB(255, 28, 23, 47),
                      elevation: 5.0,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            Text(
                              'Total Cases',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              '$totalCases',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CollegeCases(),
                        ),
                      );
                    },
                    child: Card(
                      color: Color.fromARGB(255, 28, 23, 47),
                      elevation: 5.0,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            Text(
                              'College Cases',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              '$collegeCases',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Center(
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProblemReport(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 28, 23, 47),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                    ),
                    child: Text(
                      'Report Status',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  SizedBox(height: 20), // Add space between buttons
                  ElevatedButton(
                    onPressed: () {
                      // Add logout functionality here
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 28, 23, 47),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                    ),
                    child: Text(
                      'Logout',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
