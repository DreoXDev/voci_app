import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voci_app/features/requests/data/providers.dart';
import 'package:voci_app/features/requests/domain/usecases/get_active_requests.dart';
import 'package:voci_app/features/requests/presentation/controllers/requests_controller.dart';
import 'package:voci_app/features/requests/domain/usecases/get_homeless_names.dart';

final getActiveRequestsProvider = Provider<GetActiveRequests>((ref) {
  final requestRepository = ref.watch(requestRepositoryProvider);
  return GetActiveRequests(requestRepository);
});
final getHomelessNamesProvider = Provider<GetHomelessNames>((ref) {
  final homelessRepository = ref.watch(requestsHomelessRepositoryProvider);
  return GetHomelessNames(homelessRepository);
});

final requestsControllerProvider = StateNotifierProvider<RequestsController, RequestsState>(
      (ref) => RequestsController(
    ref.watch(getActiveRequestsProvider),
    ref.watch(getHomelessNamesProvider),
  ),
);