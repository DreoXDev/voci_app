import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:voci_app/core/widgets/main_scaffold.dart';
import 'package:voci_app/features/homeless/presentation/screens/homeless_screen.dart';

import '../../features/homeless/presentation/screens/homeless_profile_screen.dart';
import '../../features/requests/presentation/screens/requests_history_screen.dart';
import '../../features/requests/presentation/screens/requests_screen.dart';

// Define a global key that will be used for the navigator
final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

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
          pageBuilder: (context, state) => CustomTransitionPage<void>(
            key: state.pageKey,
            child: const HomelessScreen(),
            transitionsBuilder: (BuildContext context,
                Animation<double> animation,
                Animation<double> secondaryAnimation,
                Widget child) {
              //is going backward
              return SharedAxisTransition(
                animation: animation,
                secondaryAnimation: secondaryAnimation,
                transitionType: SharedAxisTransitionType.horizontal,
                fillColor: Colors.transparent,
                child: child,
              );
            },
          ),
        ),
        GoRoute(
          path: '/requests',
          pageBuilder: (context, state) => CustomTransitionPage<void>(
            key: state.pageKey,
            child: const RequestsScreen(),
            transitionsBuilder: (BuildContext context,
                Animation<double> animation,
                Animation<double> secondaryAnimation,
                Widget child) {
              //is going backward
              return SharedAxisTransition(
                animation: animation,
                secondaryAnimation: secondaryAnimation,
                transitionType: SharedAxisTransitionType.horizontal,
                fillColor: Colors.transparent,
                child: child,
              );
            },
          ),
        ),
        GoRoute(
          path: '/requests/history',
          pageBuilder: (context, state) => CustomTransitionPage<void>(
            key: state.pageKey,
            child: const RequestsHistoryScreen(),
            transitionsBuilder: (BuildContext context,
                Animation<double> animation,
                Animation<double> secondaryAnimation,
                Widget child) {
              //is going backward
              return SharedAxisTransition(
                animation: animation,
                secondaryAnimation: secondaryAnimation,
                transitionType: SharedAxisTransitionType.horizontal,
                fillColor: Colors.transparent,
                child: child,
              );
            },
          ),
        ),
        GoRoute(
          path: '/homeless/:homelessId',
          builder: (context, state) {
            final homelessId = state.pathParameters['homelessId']!;
            return HomelessProfileScreen(homelessId: homelessId);
          },
        ),
      ],
    ),
  ],
);