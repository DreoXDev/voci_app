import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voci_app/core/errors/core_errors.dart';
import 'package:voci_app/core/errors/firestore_errors.dart';
import 'package:voci_app/features/requests/domain/entities/request_entity.dart';
import 'package:voci_app/features/requests/domain/usecases/get_completed_requests.dart';
import 'package:voci_app/features/requests/domain/usecases/get_homeless_names.dart';
import 'package:voci_app/features/requests/domain/usecases/delete_request.dart';
import 'package:voci_app/features/requests/domain/usecases/activate_request.dart';

class RequestsHistoryController extends StateNotifier<RequestsHistoryState> {
  final GetCompletedRequests _getCompletedRequests;
  final GetHomelessNames _getHomelessNames;
  final DeleteRequest _deleteRequest;
  final ActivateRequest _activateRequest;

  RequestsHistoryController(
      this._getCompletedRequests,
      this._getHomelessNames,
      this._deleteRequest,
      this._activateRequest,
      ) : super(RequestsHistoryState.initial());

  Future<void> getCompletedRequestsList() async {
    if (state.isLoading || !state.hasMore) {
      return;
    }
    state = state.copyWith(isLoading: true, error: null);
    try {
      final (requestsList, newLastDocument) = await _getCompletedRequests(
          GetCompletedRequestsParams(lastDocument: state.lastDocument));
      DocumentSnapshot? lastDocument = await _getCompletedRequests.repository
          .getLastVisibleDocument(
          lastDocument: state.lastDocument, status: 'DONE');
      _updateState(requestsList, newLastDocument ?? lastDocument);
      //fetch the names of the homelesses
      await getHomelessNames(requestsList);
    } on FirestoreError catch (e) {
      state = state.copyWith(
          isLoading: false, error: AsyncError(e, StackTrace.current));
    } on UnexpectedError catch (e) {
      state = state.copyWith(
          isLoading: false, error: AsyncError(e, StackTrace.current));
    } catch (error, stackTrace) {
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
      } on FirestoreError catch (e) {
        if (kDebugMode) {
          print('Error fetching homeless names: $e');
        }
      } catch (e) {
        if (kDebugMode) {
          print('Error fetching homeless names: $e');
        }
      }
    }
  }

  Future<void> deleteRequest(String requestId) async {
    try {
      await _deleteRequest(DeleteRequestParams(requestId: requestId));
      // Optionally: refresh the list after deletion
      await refreshCompletedRequestsList();
    } on FirestoreError catch (e) {
      if (kDebugMode) {
        print('Error deleting request: $e');
      }
      rethrow;
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting request: $e');
      }
      rethrow;
    }
  }

  Future<void> activateRequest(String requestId) async {
    try {
      await _activateRequest(ActivateRequestParams(requestId: requestId));
      // Optionally: refresh the list after activating
      await refreshCompletedRequestsList();
    } on FirestoreError catch (e) {
      if (kDebugMode) {
        print('Error activating request: $e');
      }
      rethrow;
    } catch (e) {
      if (kDebugMode) {
        print('Error activating request: $e');
      }
      rethrow;
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