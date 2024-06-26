import 'package:flutter/material.dart';
import 'profile.dart';
import 'report.dart';
import 'navigation.dart';
import 'home.dart';

void main() {
  runApp(MyApp());
}

class Problem {
  final String title;
  final String description;
  final String studentName;

  Problem({
    required this.title,
    required this.description,
    required this.studentName,
  });
}

class MyApp extends StatelessWidget {
  // Define primary and contrast colors
  static final Color primaryColor = Color.fromARGB(255, 28, 23, 47);
  static final Color contrastColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student Dashboard',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ComplaintDashboard(),
    );
  }
}

class ComplaintDashboard extends StatefulWidget {
  @override
  _ComplaintDashboardState createState() => _ComplaintDashboardState();
}

class _ComplaintDashboardState extends State<ComplaintDashboard> {
  int _selectedIndex = 1;

  // Define the problems list
  final List<Problem> problems = [
    Problem(
      title: 'Network Connectivity Issue',
      description: 'Unable to connect to the internet in the computer lab.',
      studentName: 'John Doe',
    ),
    Problem(
      title: 'Broken Chair in Classroom',
      description: 'One of the chairs in classroom 3B is broken.',
      studentName: 'Jane Smith',
    ),
    Problem(
      title: 'Malfunctioning Projector',
      description: 'The projector in the auditorium is not working properly.',
      studentName: 'Alice Johnson',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Student Dashboard',
          style: TextStyle(color: MyApp.contrastColor), // Text in white
        ),
        backgroundColor: MyApp.primaryColor, // AppBar color
        automaticallyImplyLeading: false, // Remove the default back button
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: MyApp.contrastColor, // Icon color
          onPressed: () {
            Navigator.pop(context); // Custom back button action
          },
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomePageMain()),
            );
          }
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ComplaintDashboard()),
            );
          }
          if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProblemReportForm()),
            );
          }
          if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfilePage()),
            );
          }
        },
      ),
      body: ListView.builder(
        itemCount: problems.length,
        itemBuilder: (context, index) {
          return ProblemCard(problem: problems[index]);
        },
      ),
    );
  }
}

class ProblemCard extends StatelessWidget {
  final Problem problem;

  ProblemCard({required this.problem});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: MyApp.primaryColor, // Card color
      margin: EdgeInsets.all(8.0),
      child: ListTile(
        title: Text(
          problem.title,
          style: TextStyle(color: MyApp.contrastColor), // Text in white
        ),
        subtitle: Text(
          problem.description,
          style: TextStyle(color: MyApp.contrastColor), // Text in white
        ),
        trailing: Text(
          'Reported by: ${problem.studentName}',
          style: TextStyle(color: MyApp.contrastColor), // Text in white
        ),
      ),
    );
  }
}
