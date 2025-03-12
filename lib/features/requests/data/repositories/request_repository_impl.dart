import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:voci_app/core/errors/core_errors.dart';
import 'package:voci_app/core/errors/firestore_errors.dart';
import 'package:voci_app/features/requests/data/datasources/requests_firestore_datasource.dart';
import 'package:voci_app/features/requests/domain/entities/request_entity.dart';
import 'package:voci_app/features/requests/domain/repositories/request_repository.dart';

class RequestRepositoryImpl implements RequestRepository {
  final RequestsFirestoreDatasource _requestsFirestoreDatasource;

  RequestRepositoryImpl(this._requestsFirestoreDatasource);

  @override
  Future<(List<RequestEntity>, DocumentSnapshot?)> getActiveRequests(
      {DocumentSnapshot? lastDocument}) async {
    try {
      final (requestsList, newLastDocument) = await _requestsFirestoreDatasource
          .getActiveRequests(lastDocument: lastDocument);
      return (
      requestsList.map((request) => request.toEntity()).toList(),
      newLastDocument
      );
    } on FirestoreError catch (e) {
      throw FirestoreError(message: e.message);
    } catch (e) {
      throw UnexpectedError(message: 'Unexpected error: ${e.toString()}');
    }
  }

  @override
  Future<(List<RequestEntity>, DocumentSnapshot?)> getCompletedRequests(
      {DocumentSnapshot? lastDocument}) async {
    try {
      final (requestsList, newLastDocument) = await _requestsFirestoreDatasource
          .getCompletedRequests(lastDocument: lastDocument);
      return (
      requestsList.map((request) => request.toEntity()).toList(),
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
      {String status = 'TODO', DocumentSnapshot? lastDocument}) async {
    try {
      return await _requestsFirestoreDatasource.getLastVisibleDocument(
          status: status, lastDocument: lastDocument);
    } on FirestoreError catch (e) {
      throw FirestoreError(message: e.message);
    } catch (e) {
      throw UnexpectedError(message: 'Unexpected error: ${e.toString()}');
    }
  }
}