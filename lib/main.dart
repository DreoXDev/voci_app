import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';
import 'features/homeless/data/datasources/homeless_firestore_datasource.dart';
import 'features/homeless/data/repositories/homeless_repository_impl.dart';
import 'features/homeless/presentation/providers.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final homelessRepository = HomelessRepositoryImpl(HomelessFirestoreDatasource());
  print('main: homelessRepository created: $homelessRepository');
  runApp(
    ProviderScope(
      overrides: [
        homelessRepositoryProvider.overrideWithValue(
          homelessRepository,
        ),
      ],
      child: const App(),
    ),
  );
}
