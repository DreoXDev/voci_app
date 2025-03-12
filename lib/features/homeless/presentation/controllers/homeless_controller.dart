import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
    print('getHomelessList: isSearch = $isSearch');
    if (state.isLoading || (!state.hasMore && !isSearch)) {
      print('getHomelessList: early return');
      return;
    }
    state = state.copyWith(isLoading: true, error: null);
    try {
      if (!isSearch) {
        print('getHomelessList: Getting homeless data');
        final homelessList = await _getHomeless(
            GetHomelessParams(lastDocument: state.lastDocument));
        DocumentSnapshot? newLastDocument = await _getHomeless.repository
            .getLastVisibleDocument(lastDocument: state.lastDocument);
        _updateState(homelessList, newLastDocument);
      } else {
        print(
            'getHomelessList: Calling searchHomelessList from getHomelessList');
        await searchHomelessList();
      }
    } catch (error, stackTrace) {
      print('getHomelessList: Error - $error');
      state = state.copyWith(
          isLoading: false, error: AsyncError(error, stackTrace));
    }
  }

  Future<void> searchHomelessList({String searchQuery = ''}) async {
    print('searchHomelessList: searchQuery = $searchQuery');
    if (state.isLoading) {
      print('searchHomelessList: early return, is loading');
      return;
    }
    if (searchQuery.isEmpty) {
      print('searchHomelessList: Empty query');
      _clearSearchResults();
      return;
    }
    if (searchQuery.length < 2) {
      print('searchHomelessList: less than 2 characters');
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
      print('searchHomelessList: Searching');
      final (homelessList, newLastDocument) = await _searchHomeless(
          SearchHomelessParams(
              searchQuery: searchQuery, lastDocument: state.lastDocument));
      print('searchHomelessList: found ${homelessList.length} homeless');
      _updateState(homelessList, newLastDocument);
    } catch (error, stackTrace) {
      print('searchHomelessList: Error - $error');
      state = state.copyWith(
          isLoading: false, error: AsyncError(error, stackTrace));
    }
  }

  Future<HomelessByIdState> getHomelessById(
      {required String homelessId}) async {
    print('getHomelessById: Started, homelessId: $homelessId');
    try {
      final getHomelessById = GetHomelessById(_repository); // <-- Changed!
      final homeless = await getHomelessById(
          GetHomelessByIdParams(homelessId: homelessId)); // <-- Changed!
      print('getHomelessById: Found homeless');
      return HomelessByIdState(value: AsyncData(homeless));
    } catch (error, stackTrace) {
      print('getHomelessById: Error - $error');
      return HomelessByIdState(value: AsyncError(error, stackTrace));
    }
  }

  void _clearSearchResults() {
    print('_clearSearchResults:');
    state = state.copyWith(
        data: [], lastDocument: null, hasMore: true, isSearching: false);
    getHomelessList();
  }

  void _updateState(
      List<HomelessEntity> homelessList, DocumentSnapshot? newLastDocument) {
    print('_updateState: new data ${homelessList.length}');
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
