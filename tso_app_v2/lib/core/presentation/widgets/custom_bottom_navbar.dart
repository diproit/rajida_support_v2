import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomBottomNavbar extends StatelessWidget {
  final Function(int) onTabTapped;
  final int currentIndex;
  const CustomBottomNavbar({
    super.key,
    required this.onTabTapped,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 85,

      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 20,
            spreadRadius: 5,
            offset: Offset(0, 1),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 0.1, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          navBarIcon(
            0,
            onTabTapped,
            'assets/icons/home_icon.png',
            currentIndex == 0,
            Colors.black,
            'Home',
          ),

          navBarIcon(
            1,
            onTabTapped,
            'assets/icons/task_icon.png',
            currentIndex == 1,
            Colors.black,
            'Tasks',
          ),

          navBarIcon(
            2,
            onTabTapped,
            'assets/icons/due_icon.png',
            currentIndex == 2,
            Colors.black,
            'Dues',
          ),
          navBarIcon(
            3,
            onTabTapped,
            'assets/icons/clients_icon.png',
            currentIndex == 3,
            Colors.black,
            'Clients',
          ),
          navBarIcon(
            4,
            onTabTapped,
            'assets/icons/attendance_icon.png',
            currentIndex == 4,
            Colors.black,
            'Attendance',
          ),
        ],
      ),
    );
  }
}

Widget navBarIcon(
  int index,
  Function(int) onTap,
  String iconPath,
  bool isActive,
  Color activeColor,
  String label,
) {
  return Expanded(
    child: InkWell(
      onTap: () => onTap(index),
      child: SizedBox(
        height: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              iconPath,
              height: 20,
              width: 20,
              color: isActive ? activeColor : Colors.black,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isActive ? activeColor : Colors.black,
                fontSize: 8,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
