import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voci_app/features/requests/domain/entities/request_entity.dart';
import 'package:voci_app/features/requests/domain/usecases/get_active_requests.dart';
import 'package:voci_app/features/requests/data/models/request.dart';
class RequestsController extends StateNotifier<RequestsState> {
  final GetActiveRequests _getActiveRequests;

  RequestsController(this._getActiveRequests) : super(RequestsState.initial());

  Future<void> getActiveRequestsList() async {
    print('getActiveRequestsList: Started');
    if (state.isLoading || !state.hasMore) {
      print('getActiveRequestsList: early return, is loading or has no more');
      return;
    }
    state = state.copyWith(isLoading: true, error: null);
    try {
      print('getActiveRequestsList: Getting requests data');
      final (requestsList, newLastDocument) = await _getActiveRequests(GetActiveRequestsParams(lastDocument: state.lastDocument));
      DocumentSnapshot? lastDocument = await _getActiveRequests.repository.getLastVisibleDocument(lastDocument: state.lastDocument);
      _updateState(requestsList,newLastDocument ?? lastDocument);
    } catch (error, stackTrace) {
      print('getActiveRequestsList: Error - $error');
      state = state.copyWith(isLoading: false, error: AsyncError(error, stackTrace));
    }
  }
  void _updateState(List<RequestEntity> requestsList, DocumentSnapshot? newLastDocument){
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