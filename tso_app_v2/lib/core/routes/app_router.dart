import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tso_app_v2/core/keys/app_navigator_keys.dart';
import 'package:tso_app_v2/core/presentation/screen/home_screen.dart';
import 'package:tso_app_v2/features/dashbord/presentation/screens/dashboard_screen.dart';

final appRouter = GoRouter(
  navigatorKey: AppNavigatorKeys.rootNavigatorKey,
  initialLocation: '/dashboard',

  routes: [
    GoRoute(
      path: '/sign_in',
      builder: (context, state) => Center(child: Text('Sign In')),
    ),

    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          HomeScreen(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/dashboard',
              builder: (context, state) => const DashboardScreen(),
            ),
          ],
        ),

        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/tasks',
              builder: (context, state) => Center(child: Text('Tasks')),
            ),
          ],
        ),

        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/dues',
              builder: (context, state) => Center(child: Text('dues')),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/clients',
              builder: (context, state) => Center(child: Text('Clients')),
            ),
          ],
        ),

        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/attendance',
              builder: (context, state) => Center(child: Text('Attendance')),
            ),
          ],
        ),
      ],
    ),
  ],
);
