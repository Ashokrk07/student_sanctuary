import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Rating',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: RatingPage(),
    );
  }
}

class RatingPage extends StatefulWidget {
  @override
  _RatingPageState createState() => _RatingPageState();
}

class _RatingPageState extends State<RatingPage> {
  double _rating = -1;
  String? _issueType;
  TextEditingController _descriptionController = TextEditingController();
  bool _isLoading = false;

  Widget buildStarRating() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        return IconButton(
          icon: Icon(
            index <= _rating ? Icons.star : Icons.star_border,
            color: Colors.yellow,
          ),
          onPressed: () {
            setState(() {
              _rating = index.toDouble();
              if (_rating >= 3) {
                _issueType = null;
                _descriptionController.clear();
              }
            });
          },
        );
      }),
    );
  }

  Future<void> _submitFeedback() async {
    if (_rating < 3 &&
        _rating >= 0 &&
        (_issueType == null || _descriptionController.text.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Please provide the issue type and description')),
      );
    } else {
      setState(() {
        _isLoading = true;
      });

      try {
        await FirebaseFirestore.instance.collection('feedback').add({
          'rating': _rating + 1,
          'issueType': _issueType,
          'description': _descriptionController.text,
          'timestamp': FieldValue.serverTimestamp(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Thank you for your feedback!')),
        );

        // Clear the input fields
        setState(() {
          _rating = -1;
          _issueType = null;
          _descriptionController.clear();
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit feedback: $e')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('App Rating', style: TextStyle(color: Colors.white)),
        backgroundColor: Color.fromARGB(255, 28, 23, 47), // Custom color
        iconTheme: IconThemeData(color: Colors.white), // White back button
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                'Rate the App',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              buildStarRating(),
              if (_rating < 3 && _rating >= 0) ...[
                SizedBox(height: 20),
                Text(
                  'Please select the type of issue:',
                  style: TextStyle(fontSize: 18),
                ),
                ListTile(
                  title: const Text('About the app'),
                  leading: Radio<String>(
                    value: 'About the app',
                    groupValue: _issueType,
                    onChanged: (String? value) {
                      setState(() {
                        _issueType = value;
                      });
                    },
                  ),
                ),
                ListTile(
                  title: const Text('Problem solving related'),
                  leading: Radio<String>(
                    value: 'Problem solving related',
                    groupValue: _issueType,
                    onChanged: (String? value) {
                      setState(() {
                        _issueType = value;
                      });
                    },
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _descriptionController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Description',
                    hintText: 'Enter a description (max 3 lines)',
                  ),
                ),
              ],
              SizedBox(height: 20),
              _isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _submitFeedback,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(
                            255, 28, 23, 47), // Custom button color
                      ),
                      child:
                          Text('Submit', style: TextStyle(color: Colors.white)),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
