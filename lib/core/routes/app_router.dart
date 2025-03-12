import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:voci_app/features/homeless/presentation/screens/home_screen.dart';
import 'package:voci_app/core/widgets/main_scaffold.dart';
import '../../features/requests/presentation/screens/requests_screen.dart';
import 'package:animations/animations.dart';

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
          pageBuilder: (context, state) => CustomTransitionPage<void>(
            key: state.pageKey,
            child: const HomeScreen(),
            transitionsBuilder: (BuildContext context,
                Animation<double> animation,
                Animation<double> secondaryAnimation,
                Widget child) {
              //is going backward
              final isGoingBackward = state.matchedLocation == "/requests";
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
              final isGoingBackward = state.matchedLocation == "/homeless";
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
      ],
    ),
  ],
);