import 'package:flutter/material.dart';

class ProblemReport extends StatefulWidget {
  @override
  _ProblemReportState createState() => _ProblemReportState();
}

class _ProblemReportState extends State<ProblemReport> {
  final problemIdController = TextEditingController();
  String _status = 'Pending';
  final descriptionController = TextEditingController();

  @override
  void dispose() {
    problemIdController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  void _submitReport() {
    // Implement your submit logic here
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Problem report submitted!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Problem Report',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(255, 28, 23, 47),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Card(
          color: Color.fromARGB(255, 28, 23, 47), // Card background color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          elevation: 8.0,
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: problemIdController,
                  decoration: InputDecoration(
                    labelText: 'Problem ID',
                    labelStyle:
                        TextStyle(color: Colors.white), // White label text
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                  style: TextStyle(color: Colors.white), // White input text
                ),
                SizedBox(height: 10.0),
                DropdownButtonFormField<String>(
                  value: _status,
                  decoration: InputDecoration(
                    labelText: 'Status',
                    labelStyle:
                        TextStyle(color: Colors.white), // White label text
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                  dropdownColor: Color.fromARGB(255, 28, 23, 47),
                  style: TextStyle(color: Colors.white), // White input text
                  items: ['Pending', 'Canceled', 'Completed']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _status = newValue!;
                    });
                  },
                ),
                SizedBox(height: 10.0),
                TextFormField(
                  controller: descriptionController,
                  maxLines: 5,
                  decoration: InputDecoration(
                    labelText: 'Problem Description',
                    labelStyle:
                        TextStyle(color: Colors.white), // White label text
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                  style: TextStyle(color: Colors.white), // White input text
                ),
                SizedBox(height: 20.0),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white, // Button background color
                    padding: EdgeInsets.symmetric(vertical: 15.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  onPressed: _submitReport,
                  child: Text(
                    'Submit',
                    style: TextStyle(
                      color:
                          Color.fromARGB(255, 28, 23, 47), // Button text color
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
