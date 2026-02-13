import 'package:flutter/material.dart';
import 'package:tso_app_v2/core/theme/app_colores.dart';

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

      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(40),
            blurRadius: 20,
            spreadRadius: 0,
            offset: Offset(0, 4),
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
            kPrimaryColor,
            'Home',
          ),

          navBarIcon(
            1,
            onTabTapped,
            'assets/icons/task_icon.png',
            currentIndex == 1,
            kPrimaryColor,
            'Tasks',
          ),

          navBarIcon(
            2,
            onTabTapped,
            'assets/icons/due_icon.png',
            currentIndex == 2,
            kPrimaryColor,
            'Dues',
          ),
          navBarIcon(
            3,
            onTabTapped,
            'assets/icons/clients_icon.png',
            currentIndex == 3,
            kPrimaryColor,
            'Clients',
          ),
          navBarIcon(
            4,
            onTabTapped,
            'assets/icons/attendance_icon.png',
            currentIndex == 4,
            kPrimaryColor,
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
