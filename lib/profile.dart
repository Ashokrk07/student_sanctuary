import 'package:flutter/material.dart';
import 'report.dart';
import 'home.dart';
import 'navigation.dart';
import 'rating.dart';
import 'password.dart';
import 'settings.dart';
import 'complaint.dart';
import 'logout.dart';
import 'status.dart';

void main() {
  runApp(ProfilePage());
}

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _selectedIndex = 3;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Profile Page', style: TextStyle(color: Colors.white)),
          backgroundColor: Color.fromARGB(255, 28, 23, 47),
          iconTheme: IconThemeData(color: Colors.white),
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        bottomNavigationBar: CustomBottomNavigationBar(
          currentIndex:
              _selectedIndex, // Assuming _selectedIndex is the index of the currently selected page
          onTap: (int index) {
            setState(() {
              _selectedIndex =
                  index; // Update the selected index when a navigation item is tapped
            });
            if (index == 0) {
              // Navigate to report page
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        HomePageMain()), // Using ReportPage defined in report.dart
              );
            }
            if (index == 1) {
              // Navigate to report page
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        ComplaintDashboard()), // Using ReportPage defined in report.dart
              );
            }
            if (index == 2) {
              // Navigate to report page
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        ProblemReportForm()), // Using ReportPage defined in report.dart
              );
            }
            if (index == 3) {
              // Navigate to report page
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        ProfilePage()), // Using ReportPage defined in report.dart
              );
            } // Handle navigation
          },
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20),
                CircleAvatar(
                  radius: 80,
                  backgroundImage: AssetImage(
                      'assets/background.jpg'), // Replace with your image path
                ),
                SizedBox(height: 20),
                Text(
                  'Ashok R K',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'ashok07@gmail.com',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 40),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        // Add functionality for my profile button
                      },
                      icon: Icon(Icons.person, color: Colors.white),
                      label: Text('My Profile',
                          style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.all(20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        backgroundColor: Color.fromARGB(255, 28, 23, 47),
                      ),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ComplaintStatusPage(),
                          ),
                        );
                        // Add functionality for complaint status button
                      },
                      icon: Icon(Icons.assignment, color: Colors.white),
                      label: Text('Complaint Status',
                          style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.all(20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        backgroundColor: Color.fromARGB(255, 28, 23, 47),
                      ),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RatingPage(),
                          ),
                        ); // Add functionality for ratings button
                      },
                      icon: Icon(Icons.star, color: Colors.white),
                      label: Text('Rate the App',
                          style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.all(20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        backgroundColor: Color.fromARGB(255, 28, 23, 47),
                      ),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChangePasswordScreen(),
                          ),
                        );
                        // Add functionality for change password button
                      },
                      icon: Icon(Icons.lock, color: Colors.white),
                      label: Text('Change Password',
                          style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.all(20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        backgroundColor: Color.fromARGB(255, 28, 23, 47),
                      ),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SettingsPage(),
                          ),
                        ); // Add functionality for settings button
                      },
                      icon: Icon(Icons.settings, color: Colors.white),
                      label: Text('Settings',
                          style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.all(20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        backgroundColor: Color.fromARGB(255, 28, 23, 47),
                      ),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LogoutPage(),
                          ),
                        ); // Add functionality for settings button
                      },
                      icon: Icon(Icons.logout, color: Colors.white),
                      label:
                          Text('Logout', style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.all(20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        backgroundColor: Color.fromARGB(255, 28, 23, 47),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
