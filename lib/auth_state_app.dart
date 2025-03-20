import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:voci_app/app.dart';
import 'package:voci_app/core/usecase/usecase.dart';
import 'package:voci_app/features/auth/domain/entities/user_entity.dart';
import 'package:voci_app/features/auth/domain/usecases/get_current_user.dart';
import 'package:voci_app/features/auth/domain/usecases/sign_in.dart';
import 'package:voci_app/features/auth/domain/usecases/sign_up.dart';
import 'package:voci_app/features/auth/presentation/screens/login_screen.dart';

class AuthStateApp extends StatefulWidget {
  final GetCurrentUser getCurrentUser;
  final SignIn signIn;
  final SignUp signUp;

  const AuthStateApp({
    super.key,
    required this.getCurrentUser,
    required this.signIn,
    required this.signUp,
  });

  @override
  State<AuthStateApp> createState() => _AuthStateAppState();
}

class _AuthStateAppState extends State<AuthStateApp> {
  late Stream<User?> authStateChanges;

  @override
  void initState() {
    super.initState();
    authStateChanges = FirebaseAuth.instance.authStateChanges();
  }

  @override
  Widget build(BuildContext context) {
    print('AuthStateApp: build() - Building AuthStateApp widget');
    return StreamBuilder<User?>(
      stream: authStateChanges,
      builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
        print(
            'AuthStateApp: StreamBuilder - StreamBuilder callback called. Connection state: ${snapshot.connectionState}');
        if (snapshot.connectionState == ConnectionState.waiting) {
          print('AuthStateApp: StreamBuilder - ConnectionState.waiting');
          return const Center(child: CircularProgressIndicator());
        } else {
          if (snapshot.hasData) {
            print('AuthStateApp: StreamBuilder - User is signed in');
            return FutureBuilder<UserEntity?>(
              future: widget.getCurrentUser.call(const NoParams()),
              builder: (BuildContext context,
                  AsyncSnapshot<UserEntity?> userSnapshot) {
                print(
                    'AuthStateApp: FutureBuilder - FutureBuilder callback called. Connection state: ${userSnapshot.connectionState}');
                if (userSnapshot.connectionState == ConnectionState.waiting) {
                  print(
                      'AuthStateApp: FutureBuilder - ConnectionState.waiting');
                  return const Center(child: CircularProgressIndicator());
                }
                print('AuthStateApp: FutureBuilder - User data loaded');
                return App(user: userSnapshot.data);
              },
            );
          } else {
            print('AuthStateApp: StreamBuilder - User is NOT signed in');
            return LoginScreen(
              signIn: widget.signIn,
              signUp: widget.signUp,
            );
          }
        }
      },
    );
  }
}