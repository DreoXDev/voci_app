import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:voci_app/features/homeless/data/datasources/homeless_firestore_datasource.dart';
import 'package:voci_app/features/homeless/domain/entities/homeless_entity.dart';
import 'package:voci_app/features/homeless/domain/repositories/homeless_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers.dart';

class HomelessRepositoryImpl implements HomelessRepository {
  final HomelessFirestoreDatasource _homelessFirestoreDatasource;
  final Ref _ref;

  HomelessRepositoryImpl(this._homelessFirestoreDatasource, this._ref);

  @override
  Future<List<HomelessEntity>> getHomelessList({DocumentSnapshot? lastDocument}) async {
    final homelessList = await _homelessFirestoreDatasource.getHomelessList(lastDocument: lastDocument);
    return homelessList.map((homeless) => homeless.toEntity()).toList();
  }

  @override
  Future<(List<HomelessEntity>, DocumentSnapshot?)> searchHomeless(
      {required String searchQuery, DocumentSnapshot? lastDocument}) async {
    final (homelessList, newLastDocument) = await _homelessFirestoreDatasource.searchHomeless(
        searchQuery: searchQuery, lastDocument: lastDocument);
    return (homelessList.map((homeless) => homeless.toEntity()).toList(), newLastDocument);
  }
  @override
  Future<DocumentSnapshot?> getLastVisibleDocument({required DocumentSnapshot? lastDocument}) async {
    return await _homelessFirestoreDatasource.getLastVisibleDocument(lastDocument: lastDocument);
  }

  @override
  Future<void> getHomelessNames({required Set<String> homelessIds}) async {
    print('getHomelessNames: Started');
    final namesMap = await _homelessFirestoreDatasource.getHomelessNames(homelessIds: homelessIds);
    _ref.read(homelessNamesProvider.notifier).state = namesMap;
    print('getHomelessNames: State updated');
  }
}