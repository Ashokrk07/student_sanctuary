import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'complaint.dart';
import 'profile.dart';
import 'report.dart';
import 'navigation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() => runApp(HomePageMainApp());

class HomePageMainApp extends StatelessWidget {
  static final Color primaryColor = Color.fromARGB(255, 28, 23, 47);
  static final Color contrastColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Complaint Dashboard',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePageMain(),
    );
  }
}

class HomePageMain extends StatefulWidget {
  @override
  _HomePageMainState createState() => _HomePageMainState();
}

class _HomePageMainState extends State<HomePageMain> {
  int totalCases = 0; // Sample data
  int solvedCases = 0; // Sample data
  int _selectedIndex = 0;

  final List<String> videoUrls1 = ['assets/video.mp4'];
  final List<String> videoUrls2 = ['assets/video1.mp4'];
  final List<String> videoUrls3 = ['assets/video2.mp4'];

  late List<VideoPlayerController> _controllers1;
  late List<VideoPlayerController> _controllers2;
  late List<VideoPlayerController> _controllers3;

  VideoPlayerController?
      _activeController; // Track the currently active video controller

  @override
  void initState() {
    super.initState();
    _controllers1 = initializeVideoControllers(videoUrls1);
    _controllers2 = initializeVideoControllers(videoUrls2);
    _controllers3 = initializeVideoControllers(videoUrls3);
    _fetchCaseCounts();
  }

  List<VideoPlayerController> initializeVideoControllers(
      List<String> videoUrls) {
    return videoUrls.map((url) {
      VideoPlayerController controller = VideoPlayerController.asset(url);
      controller.initialize().then((_) {
        setState(() {
          controller.setLooping(false); // Ensure the video doesn't loop
          controller.setVolume(0.0); // Mute the video
        });
      });
      return controller;
    }).toList();
  }

  Future<void> _fetchCaseCounts() async {
    try {
      // Fetch total number of cases
      QuerySnapshot totalCasesSnapshot =
          await FirebaseFirestore.instance.collection('problem_reports').get();
      setState(() {
        totalCases = totalCasesSnapshot.docs.length;
      });
    } catch (e) {
      print('Error fetching case counts: $e');
    }
  }

  @override
  void dispose() {
    _controllers1.forEach((controller) {
      controller.dispose();
    });
    _controllers2.forEach((controller) {
      controller.dispose();
    });
    _controllers3.forEach((controller) {
      controller.dispose();
    });
    super.dispose();
  }

  void _onVideoVisible(VideoPlayerController controller) {
    // If the new controller is not the current active controller, pause the current one
    if (_activeController != null && _activeController != controller) {
      _activeController!.pause();
    }
    // Set the new active controller and play it
    _activeController = controller;
    controller.play();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Student Complaint Dashboard',
          style:
              TextStyle(color: HomePageMainApp.contrastColor), // Text in white
        ),
        backgroundColor: HomePageMainApp.primaryColor, // AppBar color
        automaticallyImplyLeading: false, // Remove the back button
        iconTheme: IconThemeData(
            color: HomePageMainApp.contrastColor), // Back button color
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
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome to the Student Complaint Dashboard',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: HomePageMainApp
                      .primaryColor, // Primary color for emphasis
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Here you can find information about the total number of cases registered and solved in the college. Below, you will find some informational videos about how to handle various issues in the college.',
                style: TextStyle(
                  fontSize: 16,
                  color: HomePageMainApp.primaryColor, // Primary color for text
                ),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Card(
                      color: HomePageMainApp.primaryColor, // Card color
                      child: Padding(
                        padding: EdgeInsets.all(15.0),
                        child: Column(
                          children: [
                            Text(
                              'Cases Registered',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: HomePageMainApp
                                    .contrastColor, // Text in white
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              '$totalCases',
                              style: TextStyle(
                                fontSize: 24,
                                color: HomePageMainApp
                                    .contrastColor, // Text in white
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Card(
                      color: HomePageMainApp.primaryColor, // Card color
                      child: Padding(
                        padding: EdgeInsets.all(15.0),
                        child: Column(
                          children: [
                            Text(
                              'Cases Solved',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: HomePageMainApp
                                    .contrastColor, // Text in white
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              '$solvedCases',
                              style: TextStyle(
                                fontSize: 24,
                                color: HomePageMainApp
                                    .contrastColor, // Text in white
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text(
                'Informational Videos',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: HomePageMainApp
                      .primaryColor, // Primary color for emphasis
                ),
              ),
              SizedBox(height: 10),
              buildVideoCard(_controllers1[0]),
              SizedBox(height: 10),
              buildVideoCard(_controllers2[0]),
              SizedBox(height: 10),
              buildVideoCard(_controllers3[0]),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildVideoCard(VideoPlayerController controller) {
    return VisibilityDetector(
      key: Key(controller.dataSource),
      onVisibilityChanged: (VisibilityInfo info) {
        if (info.visibleFraction > 0.5) {
          _onVideoVisible(controller);
        } else if (controller.value.isPlaying) {
          controller.pause();
        }
      },
      child: SizedBox(
        height: 250, // Reduced height of the video
        child: Card(
          color: HomePageMainApp.primaryColor, // Card color
          child: controller.value.isInitialized
              ? AspectRatio(
                  aspectRatio: controller.value.aspectRatio,
                  child: VideoPlayer(controller),
                )
              : Center(
                  child: CircularProgressIndicator(
                      color: HomePageMainApp.contrastColor)), // Loader in white
        ),
      ),
    );
  }
}
