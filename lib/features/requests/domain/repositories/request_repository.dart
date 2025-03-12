import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:voci_app/features/requests/domain/entities/request_entity.dart';

import '../../data/models/request.dart';

abstract class RequestRepository {
  Future<(List<RequestEntity>, DocumentSnapshot?)> getActiveRequests(
      {DocumentSnapshot? lastDocument});

  Future<(List<RequestEntity>, DocumentSnapshot?)> getCompletedRequests(
      {DocumentSnapshot? lastDocument});

  Future<DocumentSnapshot?> getLastVisibleDocument(
      {String status = 'TODO', DocumentSnapshot? lastDocument});

  Future<String> addRequest({required RequestEntity request});

  Future<void> modifyRequest(
      {required String requestId, required Map<String, dynamic> updates});

  Future<void> deleteRequest({required String requestId});

  Future<void> updateRequestStatus(
      {required String requestId, required RequestStatus status});
}