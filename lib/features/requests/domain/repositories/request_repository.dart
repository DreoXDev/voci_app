import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:voci_app/features/requests/domain/entities/request_entity.dart';

abstract class RequestRepository {
  Future<(List<RequestEntity>, DocumentSnapshot?)> getActiveRequests({DocumentSnapshot? lastDocument});
  Future<(List<RequestEntity>, DocumentSnapshot?)> getCompletedRequests({DocumentSnapshot? lastDocument});
  Future<DocumentSnapshot?> getLastVisibleDocument({String status = 'TODO', DocumentSnapshot? lastDocument});
}