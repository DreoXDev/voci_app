import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voci_app/features/homeless/domain/entities/homeless_entity.dart';
import 'package:voci_app/features/homeless/domain/usecases/get_homeless.dart';

class HomelessController extends StateNotifier<HomelessState> {
  final GetHomeless _getHomeless;
  HomelessController(this._getHomeless) : super(HomelessState.initial());

  Future<void> getHomelessList() async {
    if (state.isLoading || !state.hasMore) return;
    state = state.copyWith(isLoading: true, error: null);
    try {
      final homelessList = await _getHomeless(GetHomelessParams(lastDocument: state.lastDocument));
      DocumentSnapshot? newLastDocument = await _getHomeless.repository.getLastVisibleDocument(lastDocument: state.lastDocument);
      _updateState(homelessList,newLastDocument);
    } catch (error, stackTrace) {
      state = state.copyWith(isLoading: false, error: AsyncError(error, stackTrace));
    }
  }
  void _updateState(List<HomelessEntity> homelessList, DocumentSnapshot? newLastDocument){
    List<HomelessEntity> updatedList;
    if (state.lastDocument == null) {
      updatedList = [...homelessList];
    } else {
      updatedList = [...state.data, ...homelessList];
    }
    state = state.copyWith(
      data: updatedList,
      lastDocument: newLastDocument,
      isLoading: false,
      hasMore: newLastDocument != null,
    );
  }
}

class HomelessState {
  final List<HomelessEntity> data;
  final DocumentSnapshot? lastDocument;
  final bool isLoading;
  final AsyncValue? error;
  final bool hasMore;

  HomelessState({
    required this.data,
    required this.lastDocument,
    required this.isLoading,
    this.error,
    required this.hasMore,
  });

  factory HomelessState.initial() => HomelessState(
    data: [],
    lastDocument: null,
    isLoading: false,
    hasMore: true,
  );

  HomelessState copyWith({
    List<HomelessEntity>? data,
    DocumentSnapshot? lastDocument,
    bool? isLoading,
    AsyncValue? error,
    bool? hasMore,
  }) {
    return HomelessState(
      data: data ?? this.data,
      lastDocument: lastDocument ?? this.lastDocument,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}