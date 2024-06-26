import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavigationBar({
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed, // Ensure labels are always visible
      currentIndex: currentIndex,
      backgroundColor: Color.fromARGB(255, 28, 23, 47),
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home, color: _getColor(0)),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.warning, color: _getColor(1)),
          label: 'Complaint',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.report, color: _getColor(2)),
          label: 'Report',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person, color: _getColor(3)),
          label: 'Profile',
        ),
      ],
      selectedItemColor: Colors.lightBlueAccent,
      unselectedItemColor:
          Colors.white, // This changes both icon and label color
      onTap: onTap,
    );
  }

  // Function to determine icon color based on index
  Color _getColor(int itemIndex) {
    return itemIndex == currentIndex ? Colors.lightBlueAccent : Colors.white;
  }
}
