import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:video_player/video_player.dart';

void main() {
  runApp(MyApp());
}

class Problem {
  final String title;
  final String description;
  final String studentName;
  final String natureOfIncident;
  final String witnessImageUrl;
  final String witnessVideoUrl;

  Problem({
    required this.title,
    required this.description,
    required this.studentName,
    required this.natureOfIncident,
    required this.witnessImageUrl,
    required this.witnessVideoUrl,
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
      home: CollegeCases(),
    );
  }
}

class CollegeCases extends StatefulWidget {
  @override
  _CollegeCasesState createState() => _CollegeCasesState();
}

class _CollegeCasesState extends State<CollegeCases> {
  final List<Problem> problems = [];
  String _collegeName = '';

  @override
  void initState() {
    super.initState();
    _fetchCollegeName();
  }

  Future<void> _fetchCollegeName() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Fetch the college name using the user's UID from the 'college' collection
        DocumentSnapshot collegeDoc = await FirebaseFirestore.instance
            .collection('college')
            .doc(user.uid)
            .get();

        Map<String, dynamic>? collegeData =
            collegeDoc.data() as Map<String, dynamic>?;

        if (collegeData != null && collegeData['college_name'] != null) {
          _collegeName = collegeData['college_name'].toLowerCase();
          fetchProblems(); // Fetch problems after retrieving the college name
        } else {
          print('College name not found');
        }
      } else {
        print('User not logged in');
      }
    } catch (e) {
      print('Error fetching college data: $e');
    }
  }

  Future<void> fetchProblems() async {
    try {
      // Query the 'problem_reports' collection where 'college' field matches the fetched college name
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('problem_reports')
          .where('college', isEqualTo: _collegeName)
          .get();

      final List<Problem> fetchedProblems = [];

      for (var doc in querySnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final userId = data['user_id'];

        if (userId != null) {
          // Fetch user data to display the student's name
          final userDoc = await FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .get();

          final userData = userDoc.data() as Map<String, dynamic>?;

          if (userData != null) {
            final problem = Problem(
              title:
                  data['location_of_incident'] ?? '', // Use appropriate fields
              natureOfIncident: data['nature_of_incident'] ?? '',
              description: data['description'] ?? '',
              studentName:
                  '${userData['first_name'] ?? ''} ${userData['last_name'] ?? ''}',
              witnessImageUrl: data['witness_image_url'] ?? '',
              witnessVideoUrl: data['witness_video_url'] ?? '',
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
          'College Cases',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(255, 28, 23, 47),
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
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
      color: Color.fromARGB(255, 28, 23, 47),
      margin: EdgeInsets.all(8.0),
      child: ListTile(
        title: Text(
          'Location of Incident: ${problem.title}',
          style: TextStyle(color: Colors.white),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Description: ${problem.description}',
              style: TextStyle(color: Colors.white),
            ),
            Text(
              'Nature of Incident: ${problem.natureOfIncident}',
              style: TextStyle(color: Colors.white),
            ),
            if (problem.witnessImageUrl.isNotEmpty)
              Image.network(problem.witnessImageUrl),
            if (problem.witnessVideoUrl.isNotEmpty)
              VideoPlayerWidget(
                  videoUrl: problem
                      .witnessVideoUrl), // Use the custom video player widget
          ],
        ),
        trailing: Text(
          'Reported by: ${problem.studentName}',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}

// Custom widget for video player
class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;

  VideoPlayerWidget({required this.videoUrl});

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {}); // Refresh the widget after the video initializes
      });
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose the controller to release resources
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
        ? Column(
            children: [
              AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              ),
              VideoProgressIndicator(_controller, allowScrubbing: true),
              IconButton(
                icon: Icon(
                  _isPlaying ? Icons.pause : Icons.play_arrow,
                  color: Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    if (_isPlaying) {
                      _controller.pause();
                    } else {
                      _controller.play();
                    }
                    _isPlaying = !_isPlaying;
                  });
                },
              ),
            ],
          )
        : Center(
            child: CircularProgressIndicator(),
          );
  }
}
