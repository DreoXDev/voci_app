import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voci_app/auth_state_app.dart';
import 'package:voci_app/core/usecase/usecase.dart';
import 'package:voci_app/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:voci_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:voci_app/features/auth/domain/usecases/get_current_user.dart';
import 'package:voci_app/features/auth/domain/usecases/sign_in.dart';
import 'package:voci_app/features/auth/domain/usecases/sign_up.dart';
import 'firebase_options.dart';

void main() async {
  print('main.dart: main() - Started');
  WidgetsFlutterBinding.ensureInitialized();
  print('main.dart: main() - WidgetsFlutterBinding initialized');
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  print('main.dart: main() - Firebase initialized');

  print('main.dart: main() - About to run ProviderScope');
  runApp(
    const ProviderScope(
      child: MainApp(),
    ),
  );
  print('main.dart: main() - ProviderScope should be running now');
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthRemoteDataSource remoteDataSource = AuthRemoteDataSourceImpl();
    print('main.dart: main() - AuthRemoteDataSource created');
    final AuthRepositoryImpl authRepository = AuthRepositoryImpl(remoteDataSource);
    print('main.dart: main() - AuthRepository created');
    final GetCurrentUser getCurrentUser = GetCurrentUser(authRepository);
    print('main.dart: main() - GetCurrentUser use case created');
    final SignIn signIn = SignIn(authRepository);
    print('main.dart: main() - SignIn use case created');
    final SignUp signUp = SignUp(authRepository);
    print('main.dart: main() - SignUp use case created');
    return MaterialApp(
      title: 'VoCi App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
        useMaterial3: true,
      ),
      home: AuthStateApp(
        getCurrentUser: getCurrentUser,
        signIn: signIn,
        signUp: signUp,
      ),
    );
  }
}