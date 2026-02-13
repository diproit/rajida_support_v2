import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tso_app_v2/core/presentation/widgets/custom_bottom_navbar.dart';
import 'package:tso_app_v2/core/theme/app_colores.dart';

class HomeScreen extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  const HomeScreen({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: SafeArea(child: navigationShell),
      bottomNavigationBar: CustomBottomNavbar(
        currentIndex: navigationShell.currentIndex,
        onTabTapped: (index) => navigationShell.goBranch(index),
      ),
    );
  }
}
