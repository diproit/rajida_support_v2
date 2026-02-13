import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tso_app_v2/core/keys/app_navigator_keys.dart';
import 'package:tso_app_v2/core/presentation/screen/home_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/otp_screen.dart';
import '../../features/auth/presentation/screens/welcome_screen.dart';
import '../../features/tasks/presentation/screens/tasks_screen.dart';

final appRouter = GoRouter(
  navigatorKey: AppNavigatorKeys.rootNavigatorKey,
  initialLocation: '/welcome',
  routes: [
    // Auth Routes (No bottom navigation)
    GoRoute(
      path: '/welcome',
      name: 'welcome',
      builder: (context, state) => const WelcomeScreen(),
    ),
    GoRoute(
      path: '/sign_in',
      name: 'signIn',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/otp',
      name: 'otp',
      builder: (context, state) {
        final mobileNumber = state.extra as String? ?? '';
        return OTPScreen(mobileNumber: mobileNumber);
      },
    ),

    // Main App Routes (With bottom navigation)
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          HomeScreen(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/dashboard',
              name: 'dashboard',
              builder: (context, state) => const Center(child: Text('Dashboard')),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/tasks',
              name: 'tasks',
              builder: (context, state) => const TasksScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/dues',
              name: 'dues',
              builder: (context, state) => const Center(child: Text('dues')),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/clients',
              name: 'clients',
              builder: (context, state) => const Center(child: Text('Clients')),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/attendance',
              name: 'attendance',
              builder: (context, state) => const Center(child: Text('Attendance')),
            ),
          ],
        ),
      ],
    ),
  ],
);