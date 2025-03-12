import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voci_app/core/providers.dart';
import 'package:voci_app/features/homeless/data/datasources/homeless_firestore_datasource.dart';
import 'package:voci_app/features/homeless/data/repositories/homeless_repository_impl.dart';
import 'package:voci_app/features/homeless/domain/repositories/homeless_repository.dart';

// Data source provider
final homelessFirestoreDatasourceProvider =
    Provider<HomelessFirestoreDatasource>(
  (ref) => HomelessFirestoreDatasource(
    firestore: ref.watch(firestoreProvider),
  ),
);

// Repository provider
final homelessRepositoryProvider = Provider<HomelessRepository>(
  (ref) => HomelessRepositoryImpl(
    ref.watch(homelessFirestoreDatasourceProvider),
    ref,
  ),
);
//Map to save the names of the homeless
final homelessNamesProvider = StateProvider<Map<String, String>>((ref) => {});
