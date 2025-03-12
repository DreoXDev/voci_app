import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:voci_app/features/requests/data/datasources/requests_firestore_datasource.dart';
import 'package:voci_app/features/requests/domain/entities/request_entity.dart';
import 'package:voci_app/features/requests/domain/repositories/request_repository.dart';

class RequestRepositoryImpl implements RequestRepository {
  final RequestsFirestoreDatasource _requestsFirestoreDatasource;

  RequestRepositoryImpl(this._requestsFirestoreDatasource);

  @override
  Future<(List<RequestEntity>, DocumentSnapshot?)> getActiveRequests(
      {DocumentSnapshot? lastDocument}) async {
    final (requestsList, newLastDocument) = await _requestsFirestoreDatasource
        .getActiveRequests(lastDocument: lastDocument);
    return (
      requestsList.map((request) => request.toEntity()).toList(),
      newLastDocument
    );
  }

  @override
  Future<(List<RequestEntity>, DocumentSnapshot?)> getCompletedRequests(
      {DocumentSnapshot? lastDocument}) async {
    final (requestsList, newLastDocument) = await _requestsFirestoreDatasource
        .getCompletedRequests(lastDocument: lastDocument);
    return (
      requestsList.map((request) => request.toEntity()).toList(),
      newLastDocument
    );
  }

  @override
  Future<DocumentSnapshot?> getLastVisibleDocument(
      {String status = 'TODO', DocumentSnapshot? lastDocument}) async {
    return await _requestsFirestoreDatasource.getLastVisibleDocument(
        status: status, lastDocument: lastDocument);
  }
}
