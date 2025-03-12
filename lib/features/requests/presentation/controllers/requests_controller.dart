import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voci_app/core/errors/core_errors.dart';
import 'package:voci_app/core/errors/firestore_errors.dart';
import 'package:voci_app/features/requests/domain/entities/request_entity.dart';
import 'package:voci_app/features/requests/domain/usecases/get_active_requests.dart';
import 'package:voci_app/features/requests/domain/usecases/get_homeless_names.dart';
import 'package:voci_app/features/requests/domain/usecases/add_request.dart';
import 'package:voci_app/features/requests/domain/usecases/modify_request.dart';
import 'package:voci_app/features/requests/domain/usecases/complete_request.dart';

class RequestsController extends StateNotifier<RequestsState> {
  final GetActiveRequests _getActiveRequests;
  final GetHomelessNames _getHomelessNames;
  final AddRequest _addRequest;
  final ModifyRequest _modifyRequest;
  final CompleteRequest _completeRequest;

  RequestsController(
      this._getActiveRequests,
      this._getHomelessNames,
      this._addRequest,
      this._modifyRequest,
      this._completeRequest,
      ) : super(RequestsState.initial());

  Future<void> getActiveRequestsList() async {
    if (state.isLoading || !state.hasMore) {
      return;
    }
    state = state.copyWith(isLoading: true, error: null);
    try {
      final (requestsList, newLastDocument) = await _getActiveRequests(
          GetActiveRequestsParams(lastDocument: state.lastDocument));
      DocumentSnapshot? lastDocument = await _getActiveRequests.repository
          .getLastVisibleDocument(lastDocument: state.lastDocument);
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

  Future<String> addRequest(RequestEntity request) async {
    try {
      final String requestId = await _addRequest(AddRequestParams(request: request));
      return requestId;
    } on FirestoreError catch (e) {
      if (kDebugMode) {
        print('Error adding request: $e');
      }
      rethrow;
    } catch (e) {
      if (kDebugMode) {
        print('Error adding request: $e');
      }
      rethrow;
    }
  }

  Future<void> modifyRequest(String requestId, Map<String, dynamic> updates) async {
    try {
      await _modifyRequest(ModifyRequestParams(requestId: requestId, updates: updates));
    } on FirestoreError catch (e) {
      if (kDebugMode) {
        print('Error modifying request: $e');
      }
      rethrow;
    } catch (e) {
      if (kDebugMode) {
        print('Error modifying request: $e');
      }
      rethrow;
    }
  }

  Future<void> completeRequest(String requestId) async {
    try {
      await _completeRequest(CompleteRequestParams(requestId: requestId));
    } on FirestoreError catch (e) {
      if (kDebugMode) {
        print('Error completing request: $e');
      }
      rethrow;
    } catch (e) {
      if (kDebugMode) {
        print('Error completing request: $e');
      }
      rethrow;
    }
  }
}

class RequestsState {
  final List<RequestEntity> data;
  final DocumentSnapshot? lastDocument;
  final bool isLoading;
  final AsyncValue? error;
  final bool hasMore;

  RequestsState({
    required this.data,
    required this.lastDocument,
    required this.isLoading,
    this.error,
    required this.hasMore,
  });

  factory RequestsState.initial() => RequestsState(
    data: [],
    lastDocument: null,
    isLoading: false,
    hasMore: true,
  );

  RequestsState copyWith({
    List<RequestEntity>? data,
    DocumentSnapshot? lastDocument,
    bool? isLoading,
    AsyncValue? error,
    bool? hasMore,
  }) {
    return RequestsState(
      data: data ?? this.data,
      lastDocument: lastDocument ?? this.lastDocument,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}