import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voci_app/core/errors/core_errors.dart'; // Import core errors
import 'package:voci_app/core/errors/firestore_errors.dart'; // Import firestore errors
import 'package:voci_app/features/homeless/data/datasources/homeless_firestore_datasource.dart';
import 'package:voci_app/features/homeless/domain/entities/homeless_entity.dart';
import 'package:voci_app/features/homeless/domain/repositories/homeless_repository.dart';

import '../providers.dart';

class HomelessRepositoryImpl implements HomelessRepository {
  final HomelessFirestoreDatasource _homelessFirestoreDatasource;
  final Ref _ref;

  HomelessRepositoryImpl(this._homelessFirestoreDatasource, this._ref);

  @override
  Future<List<HomelessEntity>> getHomelessList(
      {DocumentSnapshot? lastDocument}) async {
    try {
      final homelessList = await _homelessFirestoreDatasource.getHomelessList(
          lastDocument: lastDocument);
      return homelessList.map((homeless) => homeless.toEntity()).toList();
    } on FirestoreError catch (e) {
      throw FirestoreError(message: e.message);
    } catch (e) {
      throw UnexpectedError(message: 'Unexpected error: ${e.toString()}');
    }
  }

  @override
  Future<(List<HomelessEntity>, DocumentSnapshot?)> searchHomeless(
      {required String searchQuery, DocumentSnapshot? lastDocument}) async {
    try {
      final (homelessList, newLastDocument) =
      await _homelessFirestoreDatasource.searchHomeless(
          searchQuery: searchQuery, lastDocument: lastDocument);
      return (
      homelessList.map((homeless) => homeless.toEntity()).toList(),
      newLastDocument
      );
    } on FirestoreError catch (e) {
      throw FirestoreError(message: e.message);
    } catch (e) {
      throw UnexpectedError(message: 'Unexpected error: ${e.toString()}');
    }
  }

  @override
  Future<DocumentSnapshot?> getLastVisibleDocument(
      {required DocumentSnapshot? lastDocument}) async {
    try {
      return await _homelessFirestoreDatasource.getLastVisibleDocument(
          lastDocument: lastDocument);
    } on FirestoreError catch (e) {
      throw FirestoreError(message: e.message);
    } catch (e) {
      throw UnexpectedError(message: 'Unexpected error: ${e.toString()}');
    }
  }

  @override
  Future<void> getHomelessNames({required Set<String> homelessIds}) async {
    try {
      final namesMap = await _homelessFirestoreDatasource.getHomelessNames(
          homelessIds: homelessIds);
      _ref.read(homelessNamesProvider.notifier).state = namesMap;
    } on FirestoreError catch (e) {
      throw FirestoreError(message: e.message);
    } catch (e) {
      throw UnexpectedError(message: 'Unexpected error: ${e.toString()}');
    }
  }

  @override
  Future<HomelessEntity> getHomelessById(
      {required String homelessId}) async {
    try {
      final homeless = await _homelessFirestoreDatasource.getHomelessById(
          homelessId: homelessId);
      return homeless.toEntity();
    } on FirestoreError catch (e) {
      throw FirestoreError(message: e.message);
    }
  }
}