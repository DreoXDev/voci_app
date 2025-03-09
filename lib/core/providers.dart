import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voci_app/core/routes/app_router.dart';
import 'package:voci_app/features/homeless/data/datasources/homeless_firestore_datasource.dart';
import 'package:voci_app/features/homeless/data/repositories/homeless_repository_impl.dart';
import 'package:voci_app/features/homeless/domain/repositories/homeless_repository.dart';

// This is the provider that will provide the router
final routerProvider = appRouterProvider;
// Firestore instance provider
final firestoreProvider = Provider<FirebaseFirestore>((ref) => FirebaseFirestore.instance);

// Data source provider
final homelessFirestoreDatasourceProvider = Provider<HomelessFirestoreDatasource>(
      (ref) => HomelessFirestoreDatasource(
    firestore: ref.watch(firestoreProvider),
  ),
);

// Repository provider
final homelessRepositoryProvider = Provider<HomelessRepository>(
      (ref) => HomelessRepositoryImpl(
    ref.watch(homelessFirestoreDatasourceProvider),
  ),
);