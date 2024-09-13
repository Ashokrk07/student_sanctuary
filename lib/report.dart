import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:video_player/video_player.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home.dart';
import 'navigation.dart';
import 'profile.dart';
import 'complaint.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
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
  final TextEditingController _collegeController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
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

  String? _selectedNatureOfIncident;
  final List<String> _natureOfIncidentOptions = [
    'Bullying',
    'Harassment',
    'Ragging',
    'College Pressure'
  ];

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
      if (await videoFile.length() <= 20 * 1024 * 1024) {
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
                  'Video file is too large. Please select a video under 20MB.')),
        );
      }
    }
  }

  Future<void> _captureWitnessVideo() async {
    final pickedFile =
        await ImagePicker().pickVideo(source: ImageSource.camera);
    if (pickedFile != null) {
      File videoFile = File(pickedFile.path);
      if (await videoFile.length() <= 20 * 1024 * 1024) {
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
                  'Video file is too large. Please select a video under 20MB.')),
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

  Future<void> _uploadData() async {
    if (_formKey.currentState!.validate() && validateWitnessMedia() == null) {
      try {
        final User? user = FirebaseAuth.instance.currentUser;
        if (user == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('User not signed in')),
          );
          return;
        }

        final String uid = user.uid;
        final String problemId =
            FirebaseFirestore.instance.collection('problem_reports').doc().id;

        String? witnessImageUrl;
        if (_witnessImage != null) {
          final ref =
              FirebaseStorage.instance.ref().child('witness_images/$problemId');
          await ref.putFile(_witnessImage!);
          witnessImageUrl = await ref.getDownloadURL();
        }

        String? witnessVideoUrl;
        if (_witnessVideo != null) {
          final ref =
              FirebaseStorage.instance.ref().child('witness_videos/$problemId');
          await ref.putFile(_witnessVideo!);
          witnessVideoUrl = await ref.getDownloadURL();
        }

        await FirebaseFirestore.instance
            .collection('problem_reports')
            .doc(problemId)
            .set({
          'user_id': uid,
          'college': _collegeController.text,
          'address': _addressController.text,
          'nature_of_incident': _selectedNatureOfIncident,
          'date_of_incident': _dateTimeController.text,
          'location_of_incident': _locationController.text,
          'description': _descriptionController.text,
          'additional_comments': _additionalCommentsController.text,
          'witness_image_url': witnessImageUrl,
          'witness_video_url': witnessVideoUrl,
          'timestamp': Timestamp.now(),
          'problem_id': problemId,
        });

        _collegeController.clear();
        _addressController.clear();
        _dateTimeController.clear();
        _locationController.clear();
        _descriptionController.clear();
        _additionalCommentsController.clear();
        setState(() {
          _witnessImage = null;
          _witnessVideo = null;
          _videoPlayerController = null;
          _selectedNatureOfIncident = null;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Report submitted successfully')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit report: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(validateWitnessMedia()!)),
      );
    }
  }

  @override
  void dispose() {
    _collegeController.dispose();
    _addressController.dispose();
    _dateTimeController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    _additionalCommentsController.dispose();
    _videoPlayerController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

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
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.05,
          vertical: screenHeight * 0.02,
        ),
        child: Card(
          color: Color.fromARGB(255, 28, 23, 47),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 16.0),
                    TextFormField(
                      controller: _collegeController,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'College Name',
                        labelStyle: TextStyle(color: Colors.white),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your college name';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.0),
                    TextFormField(
                      controller: _addressController,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Address',
                        labelStyle: TextStyle(color: Colors.white),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your address';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.0),
                    DropdownButtonFormField<String>(
                      value: _selectedNatureOfIncident,
                      decoration: InputDecoration(
                        labelText: 'Nature of Incident',
                        labelStyle: TextStyle(color: Colors.white),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                      items: _natureOfIncidentOptions
                          .map((incident) => DropdownMenuItem(
                                value: incident,
                                child: Text(
                                  incident,
                                  style: TextStyle(color: Colors.blue),
                                ),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedNatureOfIncident = value;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select the nature of the incident';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.0),
                    TextFormField(
                      controller: _dateTimeController,
                      readOnly: true,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Date of Incident',
                        labelStyle: TextStyle(color: Colors.white),
                        suffixIcon:
                            Icon(Icons.calendar_today, color: Colors.white),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                      onTap: () => _selectDateTime(context),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select the date of the incident';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.0),
                    TextFormField(
                      controller: _locationController,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Location of Incident',
                        labelStyle: TextStyle(color: Colors.white),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the location of the incident';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.0),
                    TextFormField(
                      controller: _descriptionController,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Description',
                        labelStyle: TextStyle(color: Colors.white),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a description of the incident';
                        }
                        return null;
                      },
                      maxLines: 3,
                    ),
                    SizedBox(height: 16.0),
                    TextFormField(
                      controller: _additionalCommentsController,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Additional Comments',
                        labelStyle: TextStyle(color: Colors.white),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                      maxLines: 3,
                    ),
                    SizedBox(height: 16.0),
                    Text(
                      'Upload Witness Image:',
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(height: 8.0),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: _pickWitnessImage,
                          child: Text('Select Image'),
                        ),
                        SizedBox(width: 8.0),
                        ElevatedButton(
                          onPressed: _takeWitnessPicture,
                          child: Text('Capture Image'),
                        ),
                      ],
                    ),
                    if (_witnessImage != null)
                      Column(
                        children: [
                          SizedBox(height: 8.0),
                          Image.file(
                            _witnessImage!,
                            height: 200,
                          ),
                        ],
                      ),
                    SizedBox(height: 16.0),
                    Text(
                      'Upload Witness Video:',
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(height: 8.0),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: _pickWitnessVideo,
                          child: Text('Select Video'),
                        ),
                        SizedBox(width: 8.0),
                        ElevatedButton(
                          onPressed: _captureWitnessVideo,
                          child: Text('Capture Video'),
                        ),
                      ],
                    ),
                    if (_witnessVideo != null)
                      Column(
                        children: [
                          SizedBox(height: 8.0),
                          _videoPlayerController != null &&
                                  _videoPlayerController!.value.isInitialized
                              ? AspectRatio(
                                  aspectRatio:
                                      _videoPlayerController!.value.aspectRatio,
                                  child: VideoPlayer(_videoPlayerController!),
                                )
                              : Container(),
                        ],
                      ),
                    SizedBox(height: 24.0),
                    Center(
                      child: ElevatedButton(
                        onPressed: _uploadData,
                        child: Text('Submit Report'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
