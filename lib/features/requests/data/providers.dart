import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voci_app/core/providers.dart';
import 'package:voci_app/features/homeless/domain/repositories/homeless_repository.dart';
import 'package:voci_app/features/requests/data/datasources/requests_firestore_datasource.dart';
import 'package:voci_app/features/requests/data/repositories/request_repository_impl.dart';
import 'package:voci_app/features/requests/domain/repositories/request_repository.dart';

import '../../homeless/data/providers.dart';

// Data source provider
final requestsFirestoreDatasourceProvider =
    Provider<RequestsFirestoreDatasource>(
  (ref) => RequestsFirestoreDatasource(
    firestore: ref.watch(firestoreProvider),
  ),
);

// Repository provider
final requestRepositoryProvider = Provider<RequestRepository>(
  (ref) => RequestRepositoryImpl(
    ref.watch(requestsFirestoreDatasourceProvider),
  ),
);
// Repository provider for the homeless
final requestsHomelessRepositoryProvider = Provider<HomelessRepository>(
    (ref) => ref.watch(homelessRepositoryProvider));
