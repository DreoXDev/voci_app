import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:voci_app/features/homeless/presentation/screens/home_screen.dart';
import 'package:voci_app/core/widgets/main_scaffold.dart';
import '../../features/requests/presentation/screens/requests_screen.dart';

// Define a global key that will be used for the navigator
final GlobalKey<NavigatorState> _rootNavigatorKey =
GlobalKey<NavigatorState>();

final appRouterProvider = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/homeless',
  routes: [
    // Define the route used for the MainScaffold
    ShellRoute(
      navigatorKey: GlobalKey<NavigatorState>(),
      builder: (context, state, child) => MainScaffold(child: child),
      routes: [
        // Define the routes for each screen
        GoRoute(
          path: '/homeless',
          pageBuilder: (context, state) => NoTransitionPage(
            key: state.pageKey,
            child: const HomeScreen(),
          ),
        ),
        GoRoute(
          path: '/requests',
          pageBuilder: (context, state) => NoTransitionPage(
            key: state.pageKey,
            child: const RequestsScreen(),
          ),
        ),
      ],
    ),
  ],
);