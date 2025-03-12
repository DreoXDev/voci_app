import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voci_app/core/errors/core_errors.dart';
import 'package:voci_app/core/errors/firestore_errors.dart';
import 'package:voci_app/features/requests/domain/entities/request_entity.dart';
import 'package:voci_app/features/requests/domain/usecases/get_active_requests.dart';
import 'package:voci_app/features/requests/domain/usecases/get_homeless_names.dart';

class RequestsController extends StateNotifier<RequestsState> {
  final GetActiveRequests _getActiveRequests;
  final GetHomelessNames _getHomelessNames;

  RequestsController(this._getActiveRequests, this._getHomelessNames)
      : super(RequestsState.initial());

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