import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voci_app/features/requests/data/providers.dart';
import 'package:voci_app/features/requests/domain/usecases/get_active_requests.dart';
import 'package:voci_app/features/requests/domain/usecases/get_homeless_names.dart';
import 'package:voci_app/features/requests/presentation/controllers/requests_controller.dart';
import '../domain/usecases/get_completed_requests.dart';
import '../domain/usecases/add_request.dart';
import '../domain/usecases/modify_request.dart';
import '../domain/usecases/delete_request.dart';
import '../domain/usecases/complete_request.dart';
import '../domain/usecases/activate_request.dart';
import 'controllers/requests_history_controller.dart';

final getActiveRequestsProvider = Provider<GetActiveRequests>((ref) {
  final requestRepository = ref.watch(requestRepositoryProvider);
  return GetActiveRequests(requestRepository);
});

final getCompletedRequestsProvider = Provider<GetCompletedRequests>((ref) {
  final requestRepository = ref.read(requestRepositoryProvider);
  return GetCompletedRequests(requestRepository);
});

final getHomelessNamesProvider = Provider<GetHomelessNames>((ref) {
  final homelessRepository = ref.watch(requestsHomelessRepositoryProvider);
  return GetHomelessNames(homelessRepository);
});

// New providers for the new use cases
final addRequestProvider = Provider<AddRequest>((ref) {
  final requestRepository = ref.watch(requestRepositoryProvider);
  return AddRequest(requestRepository);
});

final modifyRequestProvider = Provider<ModifyRequest>((ref) {
  final requestRepository = ref.watch(requestRepositoryProvider);
  return ModifyRequest(requestRepository);
});

final deleteRequestProvider = Provider<DeleteRequest>((ref) {
  final requestRepository = ref.watch(requestRepositoryProvider);
  return DeleteRequest(requestRepository);
});

final completeRequestProvider = Provider<CompleteRequest>((ref) {
  final requestRepository = ref.watch(requestRepositoryProvider);
  return CompleteRequest(requestRepository);
});

final activateRequestProvider = Provider<ActivateRequest>((ref) {
  final requestRepository = ref.watch(requestRepositoryProvider);
  return ActivateRequest(requestRepository);
});

final requestsControllerProvider =
StateNotifierProvider<RequestsController, RequestsState>(
      (ref) => RequestsController(
    ref.watch(getActiveRequestsProvider),
    ref.watch(getHomelessNamesProvider),
    ref.watch(addRequestProvider),
    ref.watch(modifyRequestProvider),
    ref.watch(completeRequestProvider),
  ),
);

final requestsHistoryControllerProvider = StateNotifierProvider<
    RequestsHistoryController, RequestsHistoryState>((ref) {
  final getCompletedRequests = ref.read(getCompletedRequestsProvider);
  final getHomelessNames = ref.read(getHomelessNamesProvider);
  return RequestsHistoryController(
      getCompletedRequests,
      getHomelessNames,
      ref.watch(deleteRequestProvider),
      ref.watch(activateRequestProvider)
  );
});