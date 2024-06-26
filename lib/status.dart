import 'package:flutter/material.dart';

class ComplaintStatusPage extends StatelessWidget {
  // Simulate the status of the complaints
  final List<Map<String, String?>> complaints = [
    {
      'nature': 'Ragging',
      'description': 'Students harassing juniors in the college premises.',
      'status': 'pending',
    },
    {
      'nature': 'Harassment',
      'description': 'A case of verbal harassment reported by a student.',
      'status': 'completed',
    },
    {
      'nature': 'College Pressure',
      'description': 'Students facing undue pressure from college authorities.',
      'status': 'ongoing',
    },
    {
      'nature': 'College Pressure',
      'description': 'A case of exam pressure given by college.',
      'status': 'canceled',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Complaint Status', style: TextStyle(color: Colors.white)),
        backgroundColor: Color.fromARGB(255, 28, 23, 47),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: complaints.length,
          itemBuilder: (context, index) {
            return Card(
              color: Color.fromARGB(255, 28, 23, 47),
              elevation: 5.0,
              margin: EdgeInsets.symmetric(vertical: 8.0),
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Nature of Incident:',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            complaints[index]['nature'] ?? 'N/A',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Description:',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            complaints[index]['description'] ?? 'N/A',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        padding: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: _getStatusColor(complaints[index]['status']),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Text(
                          complaints[index]['status'] ?? 'N/A',
                          style: TextStyle(fontSize: 14, color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Color _getStatusColor(String? status) {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'completed':
        return Colors.green;
      case 'ongoing':
        return Colors.blue;
      case 'canceled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}

void main() {
  runApp(MaterialApp(
    home: ComplaintStatusPage(),
  ));
}
