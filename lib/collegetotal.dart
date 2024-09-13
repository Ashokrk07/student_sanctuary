import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
      title: 'College Dashboard',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CollegeTotalCases(),
    );
  }
}

class CollegeTotalCases extends StatefulWidget {
  @override
  _CollegeTotalCasesState createState() => _CollegeTotalCasesState();
}

class _CollegeTotalCasesState extends State<CollegeTotalCases> {
  // Define the problems list
  final List<Problem> problems = [];
  @override
  void initState() {
    super.initState();
    // Fetch initial data from Firestore
    fetchProblems();
  }

  Future<void> fetchProblems() async {
    try {
      final QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('problem_reports').get();

      // Fetch user data for each problem report
      final List<Problem> fetchedProblems = [];

      for (var doc in querySnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final userId = data['user_id'];

        if (userId != null) {
          final userDoc = await FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .get();

          final userData = userDoc.data() as Map<String, dynamic>?;

          if (userData != null) {
            final problem = Problem(
              title: data['nature_of_incident'] ?? '',
              description: data['description'] ?? '',
              studentName:
                  '${userData['first_name'] ?? ''} ${userData['last_name'] ?? ''}',
            );
            fetchedProblems.add(problem);
          }
        }
      }

      setState(() {
        problems.addAll(fetchedProblems);
      });
    } catch (e) {
      print('Error fetching problems: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Total Cases',
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
