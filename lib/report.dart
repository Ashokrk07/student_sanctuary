import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:video_player/video_player.dart'; // Import the video_player package
import 'home.dart';
import 'navigation.dart';
import 'profile.dart';
import 'complaint.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // Define primary and contrast colors
  static final Color primaryColor = Color.fromARGB(255, 28, 23, 47);
  static final Color contrastColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Problem Report Form',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ProblemReportForm(),
    );
  }
}

class ProblemReportForm extends StatefulWidget {
  @override
  _ProblemReportFormState createState() => _ProblemReportFormState();
}

class _ProblemReportFormState extends State<ProblemReportForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _natureOfIncidentController =
      TextEditingController();
  final TextEditingController _dateTimeController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _additionalCommentsController =
      TextEditingController();
  late DateTime selectedDateTime;
  int _selectedIndex = 2;

  File? _witnessImage;
  File? _witnessVideo;
  VideoPlayerController? _videoPlayerController;

  String? validateWitnessMedia() {
    if (_witnessImage == null && _witnessVideo == null) {
      return 'Please select either a witness image or video';
    }
    return null;
  }

  Future<void> _pickWitnessImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _witnessImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _takeWitnessPicture() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _witnessImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _pickWitnessVideo() async {
    final pickedFile =
        await ImagePicker().pickVideo(source: ImageSource.gallery);
    if (pickedFile != null) {
      File videoFile = File(pickedFile.path);
      if (await videoFile.length() <= 100 * 1024 * 1024) {
        // Check if file is less than 100MB
        setState(() {
          _witnessVideo = videoFile;
          _videoPlayerController = VideoPlayerController.file(videoFile)
            ..initialize().then((_) {
              setState(() {});
              _videoPlayerController!.play();
            });
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Video file is too large. Please select a video under 100MB.')),
        );
      }
    }
  }

  Future<void> _captureWitnessVideo() async {
    final pickedFile =
        await ImagePicker().pickVideo(source: ImageSource.camera);
    if (pickedFile != null) {
      File videoFile = File(pickedFile.path);
      if (await videoFile.length() <= 100 * 1024 * 1024) {
        // Check if file is less than 100MB
        setState(() {
          _witnessVideo = videoFile;
          _videoPlayerController = VideoPlayerController.file(videoFile)
            ..initialize().then((_) {
              setState(() {});
              _videoPlayerController!.play();
            });
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Video file is too large. Please select a video under 100MB.')),
        );
      }
    }
  }

  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      setState(() {
        selectedDateTime = pickedDate;
        _dateTimeController.text =
            DateFormat('yyyy-MM-dd').format(selectedDateTime);
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _natureOfIncidentController.dispose();
    _dateTimeController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    _additionalCommentsController.dispose();
    _videoPlayerController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Problem Report Form',
          style: TextStyle(color: MyApp.contrastColor),
        ),
        backgroundColor: MyApp.primaryColor,
        automaticallyImplyLeading: true,
        iconTheme: IconThemeData(color: Colors.white),
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
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Card(
            color: MyApp.primaryColor,
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  TextFormField(
                    controller: _nameController,
                    style: TextStyle(color: MyApp.contrastColor),
                    decoration: InputDecoration(
                      labelText: 'Name *',
                      labelStyle: TextStyle(color: MyApp.contrastColor),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: MyApp.contrastColor),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: MyApp.contrastColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: MyApp.contrastColor),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.0),
                  GestureDetector(
                    onTap: () {
                      _selectDateTime(context);
                    },
                    child: AbsorbPointer(
                      child: TextFormField(
                        controller: _dateTimeController,
                        style: TextStyle(color: MyApp.contrastColor),
                        decoration: InputDecoration(
                          labelText: 'Date of Incident *',
                          labelStyle: TextStyle(color: MyApp.contrastColor),
                          suffixIcon: Icon(
                            Icons.calendar_today,
                            color: MyApp.contrastColor,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(color: MyApp.contrastColor),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(color: MyApp.contrastColor),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(color: MyApp.contrastColor),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select date of incident';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    controller: _addressController,
                    maxLines: 3,
                    style: TextStyle(color: MyApp.contrastColor),
                    decoration: InputDecoration(
                      labelText: 'Address of Incident *',
                      labelStyle: TextStyle(color: MyApp.contrastColor),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: MyApp.contrastColor),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: MyApp.contrastColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: MyApp.contrastColor),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter address of incident';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    controller: _locationController,
                    style: TextStyle(color: MyApp.contrastColor),
                    decoration: InputDecoration(
                      labelText: 'Specific Location of Incident *',
                      labelStyle: TextStyle(color: MyApp.contrastColor),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: MyApp.contrastColor),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: MyApp.contrastColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: MyApp.contrastColor),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter specific location of incident';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    controller: _natureOfIncidentController,
                    maxLines: 3,
                    style: TextStyle(color: MyApp.contrastColor),
                    decoration: InputDecoration(
                      labelText: 'Nature of Incident *',
                      labelStyle: TextStyle(color: MyApp.contrastColor),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: MyApp.contrastColor),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: MyApp.contrastColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: MyApp.contrastColor),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please describe the nature of incident';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    controller: _descriptionController,
                    maxLines: 3,
                    style: TextStyle(color: MyApp.contrastColor),
                    decoration: InputDecoration(
                      labelText: 'Description *',
                      labelStyle: TextStyle(color: MyApp.contrastColor),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: MyApp.contrastColor),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: MyApp.contrastColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: MyApp.contrastColor),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please describe the incident';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    controller: _additionalCommentsController,
                    maxLines: 3,
                    style: TextStyle(color: MyApp.contrastColor),
                    decoration: InputDecoration(
                      labelText: 'Additional Comments',
                      labelStyle: TextStyle(color: MyApp.contrastColor),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: MyApp.contrastColor),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: MyApp.contrastColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: MyApp.contrastColor),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Row(
                    children: [
                      Text(
                        'Witness Image:',
                        style: TextStyle(color: MyApp.contrastColor),
                      ),
                      SizedBox(width: 16.0),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _pickWitnessImage,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors
                                .transparent, // Set the button background color to transparent
                            shadowColor: Colors.transparent, // Disable shadow
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                              side: BorderSide(
                                  color: MyApp.contrastColor), // Border color
                            ),
                          ),
                          child: Text(
                            'Select Image',
                            style: TextStyle(
                              color: MyApp.contrastColor,
                              fontSize: 16.0, // Adjust text size as needed
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 16.0),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _takeWitnessPicture,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors
                                .transparent, // Set the button background color to transparent
                            shadowColor: Colors.transparent, // Disable shadow
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                              side: BorderSide(
                                  color: MyApp.contrastColor), // Border color
                            ),
                          ),
                          child: Text(
                            'Take Picture',
                            style: TextStyle(
                              color: MyApp.contrastColor,
                              fontSize: 16.0, // Adjust text size as needed
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.0),
                  if (_witnessImage != null)
                    Column(
                      children: [
                        Image.file(
                          _witnessImage!,
                          height: 200,
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _witnessImage = null;
                            });
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.white,
                          ),
                          child: Text(
                            'Remove Image',
                            style: TextStyle(
                                color: Color.fromARGB(255, 28, 23, 47)),
                          ),
                        ),
                      ],
                    ),
                  SizedBox(height: 16.0),
                  Row(
                    children: [
                      Text(
                        'Witness Video:',
                        style: TextStyle(color: MyApp.contrastColor),
                      ),
                      SizedBox(width: 16.0),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _pickWitnessVideo,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors
                                .transparent, // Set the button background color to transparent
                            shadowColor: Colors.transparent, // Disable shadow
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                              side: BorderSide(
                                  color: MyApp.contrastColor), // Border color
                            ),
                          ),
                          child: Text(
                            'Select Video',
                            style: TextStyle(
                              color: MyApp.contrastColor,
                              fontSize: 16.0, // Adjust text size as needed
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 16.0),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _captureWitnessVideo,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors
                                .transparent, // Set the button background color to transparent
                            shadowColor: Colors.transparent, // Disable shadow
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                              side: BorderSide(
                                  color: MyApp.contrastColor), // Border color
                            ),
                          ),
                          child: Text(
                            'Capture Video',
                            style: TextStyle(
                              color: MyApp.contrastColor,
                              fontSize: 16.0, // Adjust text size as needed
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.0),
                  if (_witnessVideo != null)
                    Column(
                      children: [
                        if (_videoPlayerController != null &&
                            _videoPlayerController!.value.isInitialized)
                          AspectRatio(
                            aspectRatio:
                                _videoPlayerController!.value.aspectRatio,
                            child: VideoPlayer(_videoPlayerController!),
                          ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _witnessVideo = null;
                              _videoPlayerController?.dispose();
                              _videoPlayerController = null;
                            });
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.white,
                          ),
                          child: Text(
                            'Remove Video',
                            style: TextStyle(
                                color: Color.fromARGB(255, 28, 23, 47)),
                          ),
                        ),
                      ],
                    ),
                  SizedBox(height: 16.0),
                  Padding(
                    padding: EdgeInsets.all(12.0), // Adjust padding as needed
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // Process form submission
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: MyApp.contrastColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 12.0), // Vertical padding
                        child: Text(
                          'Submit Report',
                          style: TextStyle(
                            color: MyApp.primaryColor,
                            fontSize: 16.0, // Adjust font size as needed
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
