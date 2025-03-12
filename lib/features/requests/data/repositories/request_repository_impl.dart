import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:voci_app/core/errors/core_errors.dart';
import 'package:voci_app/core/errors/firestore_errors.dart';
import 'package:voci_app/features/requests/data/datasources/requests_firestore_datasource.dart';
import 'package:voci_app/features/requests/domain/entities/request_entity.dart';
import 'package:voci_app/features/requests/domain/repositories/request_repository.dart';

import '../models/request.dart';

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
      newLastDocument,
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
      newLastDocument,
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

  @override
  Future<String> addRequest({required RequestEntity request}) async {
    try {
      final requestData = await _requestsFirestoreDatasource.addRequest(request: request.toModel());
      return requestData;
    } on FirestoreError catch (e) {
      throw FirestoreError(message: e.message);
    } catch (e) {
      throw UnexpectedError(message: 'Unexpected error: ${e.toString()}');
    }
  }

  @override
  Future<void> modifyRequest(
      {required String requestId,
        required Map<String, dynamic> updates}) async {
    try {
      await _requestsFirestoreDatasource.modifyRequest(
          requestId: requestId, updates: updates);
    } on FirestoreError catch (e) {
      throw FirestoreError(message: e.message);
    } catch (e) {
      throw UnexpectedError(message: 'Unexpected error: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteRequest({required String requestId}) async {
    try {
      await _requestsFirestoreDatasource.deleteRequest(requestId: requestId);
    } on FirestoreError catch (e) {
      throw FirestoreError(message: e.message);
    } catch (e) {
      throw UnexpectedError(message: 'Unexpected error: ${e.toString()}');
    }
  }

  @override
  Future<void> updateRequestStatus(
      {required String requestId, required RequestStatus status}) async {
    try {
      await _requestsFirestoreDatasource.updateRequestStatus(
          requestId: requestId, status: status);
    } on FirestoreError catch (e) {
      throw FirestoreError(message: e.message);
    } catch (e) {
      throw UnexpectedError(message: 'Unexpected error: ${e.toString()}');
    }
  }
}