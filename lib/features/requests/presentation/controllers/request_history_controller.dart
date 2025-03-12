import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voci_app/features/requests/domain/entities/request_entity.dart';
import 'package:voci_app/features/requests/domain/usecases/get_completed_requests.dart';
import 'package:voci_app/features/requests/domain/usecases/get_homeless_names.dart';

class RequestsHistoryController extends StateNotifier<RequestsHistoryState> {
  final GetCompletedRequests _getCompletedRequests;
  final GetHomelessNames _getHomelessNames;

  RequestsHistoryController(
      this._getCompletedRequests, this._getHomelessNames)
      : super(RequestsHistoryState.initial());

  Future<void> getCompletedRequestsList() async {
    print('getCompletedRequestsList: Started');
    if (state.isLoading || !state.hasMore) {
      print('getCompletedRequestsList: early return, is loading or has no more');
      return;
    }
    state = state.copyWith(isLoading: true, error: null);
    try {
      print('getCompletedRequestsList: Getting requests data');
      final (requestsList, newLastDocument) = await _getCompletedRequests(
          GetCompletedRequestsParams(lastDocument: state.lastDocument));
      DocumentSnapshot? lastDocument = await _getCompletedRequests.repository
          .getLastVisibleDocument(lastDocument: state.lastDocument);
      _updateState(requestsList, newLastDocument ?? lastDocument);
      //fetch the names of the homelesses
      await getHomelessNames(requestsList);
    } catch (error, stackTrace) {
      print('getCompletedRequestsList: Error - $error');
      state = state.copyWith(
          isLoading: false, error: AsyncError(error, stackTrace));
    }
  }
  Future<void> refreshCompletedRequestsList() async {
    _clearData(); // Reset pagination state
    await getCompletedRequestsList(); // Reload data
  }
  void _clearData() {
    state = state.copyWith(
      data: [],
      lastDocument: null,
      isLoading: false,
      hasMore: true,
    );
  }

  void _updateState(
      List<RequestEntity> requestsList, DocumentSnapshot? newLastDocument) {
    print('_updateState: new data ${requestsList.length}');
    List<RequestEntity> updatedList;
    if (state.lastDocument == null) {
      updatedList = [...requestsList];
    } else {
      updatedList = [...state.data, ...requestsList];
    }
    state = state.copyWith(
      data: updatedList,
      lastDocument: newLastDocument,
      isLoading: false,
      hasMore: newLastDocument != null,
    );
  }

  Future<void> getHomelessNames(List<RequestEntity> requests) async {
    // Get all unique homeless IDs from the requests.
    final Set<String> homelessIds = requests.map((r) => r.homelessID).toSet();

    if (homelessIds.isNotEmpty) {
      try {
        // Fetch the homeless names for the IDs
        await _getHomelessNames(
            GetHomelessNamesParams(homelessIds: homelessIds));
      } catch (e) {
        print('getHomelessNames: Error fetching names - $e');
      }
    }
  }
}

class RequestsHistoryState {
  final List<RequestEntity> data;
  final DocumentSnapshot? lastDocument;
  final bool isLoading;
  final AsyncValue? error;
  final bool hasMore;

  RequestsHistoryState({
    required this.data,
    required this.lastDocument,
    required this.isLoading,
    this.error,
    required this.hasMore,
  });

  factory RequestsHistoryState.initial() => RequestsHistoryState(
    data: [],
    lastDocument: null,
    isLoading: false,
    hasMore: true,
  );

  RequestsHistoryState copyWith({
    List<RequestEntity>? data,
    DocumentSnapshot? lastDocument,
    bool? isLoading,
    AsyncValue? error,
    bool? hasMore,
  }) {
    return RequestsHistoryState(
      data: data ?? this.data,
      lastDocument: lastDocument ?? this.lastDocument,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}