import 'package:flutter/material.dart';

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
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student Dashboard',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CollegeCases(),
    );
  }
}

class CollegeCases extends StatefulWidget {
  @override
  _CollegeCasesState createState() => _CollegeCasesState();
}

class _CollegeCasesState extends State<CollegeCases> {
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
          'College Cases',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(255, 28, 23, 47),
        automaticallyImplyLeading: false, // Remove the default back button
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // Custom back button action
          },
        ),
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
      color: Color.fromARGB(255, 28, 23, 47), // Set card background color
      margin: EdgeInsets.all(8.0),
      child: ListTile(
        title: Text(
          problem.title,
          style: TextStyle(color: Colors.white),
        ),
        subtitle: Text(
          problem.description,
          style: TextStyle(color: Colors.white),
        ),
        trailing: Text(
          'Reported by: ${problem.studentName}',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
