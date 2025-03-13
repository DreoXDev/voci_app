import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voci_app/core/errors/core_errors.dart';
import 'package:voci_app/core/errors/firestore_errors.dart';
import 'package:voci_app/features/homeless/domain/entities/homeless_entity.dart';
import 'package:voci_app/features/homeless/domain/repositories/homeless_repository.dart';
import 'package:voci_app/features/homeless/domain/usecases/get_homeless.dart';
import 'package:voci_app/features/homeless/domain/usecases/get_homeless_by_id.dart';
import 'package:voci_app/features/homeless/domain/usecases/search_homeless.dart';

class HomelessController extends StateNotifier<HomelessState> {
  final GetHomeless _getHomeless;
  final SearchHomeless _searchHomeless;
  final HomelessRepository _repository;

  HomelessController(this._getHomeless, this._searchHomeless, this._repository)
      : super(HomelessState.initial());

  Future<void> getHomelessList({bool isSearch = false}) async {
    if (state.isLoading || (!state.hasMore && !isSearch)) {
      return;
    }
    state = state.copyWith(isLoading: true, error: null);
    try {
      if (!isSearch) {
        final homelessList = await _getHomeless(
            GetHomelessParams(lastDocument: state.lastDocument));
        DocumentSnapshot? newLastDocument = await _getHomeless.repository
            .getLastVisibleDocument(lastDocument: state.lastDocument);
        _updateState(homelessList, newLastDocument);
      } else {
        await searchHomelessList();
      }
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

  Future<void> searchHomelessList({String searchQuery = ''}) async {
    if (state.isLoading) {
      return;
    }
    if (searchQuery.isEmpty) {
      _clearSearchResults();
      return;
    }
    if (searchQuery.length < 2) {
      return;
    }
    state = state.copyWith(
        isLoading: true,
        error: null,
        data: [],
        lastDocument: null,
        hasMore: true,
        isSearching: true);
    try {
      final (homelessList, newLastDocument) = await _searchHomeless(
          SearchHomelessParams(
              searchQuery: searchQuery, lastDocument: state.lastDocument));
      _updateState(homelessList, newLastDocument);
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

  Future<HomelessByIdState> getHomelessById(
      {required String homelessId}) async {
    try {
      final getHomelessById = GetHomelessById(_repository);
      final homeless = await getHomelessById(
          GetHomelessByIdParams(homelessId: homelessId));
      return HomelessByIdState(value: AsyncData(homeless));
    } on FirestoreError catch (e) {
      return HomelessByIdState(
          value: AsyncError(e, StackTrace.current));
    }
  }

  void _clearSearchResults() {
    state = state.copyWith(
        data: [], lastDocument: null, hasMore: true, isSearching: false);
    getHomelessList();
  }

  void _updateState(
      List<HomelessEntity> homelessList, DocumentSnapshot? newLastDocument) {
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

  bool getIsSearching() {
    return state.isSearching;
  }
}

class HomelessState {
  final List<HomelessEntity> data;
  final DocumentSnapshot? lastDocument;
  final bool isLoading;
  final AsyncValue? error;
  final bool hasMore;
  final bool isSearching;

  HomelessState({
    required this.data,
    required this.lastDocument,
    required this.isLoading,
    this.error,
    required this.hasMore,
    required this.isSearching,
  });

  factory HomelessState.initial() => HomelessState(
    data: [],
    lastDocument: null,
    isLoading: false,
    hasMore: true,
    isSearching: false,
  );

  HomelessState copyWith(
      {List<HomelessEntity>? data,
        DocumentSnapshot? lastDocument,
        bool? isLoading,
        AsyncValue? error,
        bool? hasMore,
        bool? isSearching}) {
    return HomelessState(
      data: data ?? this.data,
      lastDocument: lastDocument ?? this.lastDocument,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      hasMore: hasMore ?? this.hasMore,
      isSearching: isSearching ?? this.isSearching,
    );
  }
}

class HomelessByIdState {
  final AsyncValue<HomelessEntity> value;

  HomelessByIdState({required this.value});
}