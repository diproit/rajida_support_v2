import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tso_app_v2/core/presentation/widgets/custom_bottom_navbar.dart';

class HomeScreen extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  const HomeScreen({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: CustomBottomNavbar(
        currentIndex: navigationShell.currentIndex,
        onTabTapped: (index) => navigationShell.goBranch(index),
      ),
    );
  }
}
