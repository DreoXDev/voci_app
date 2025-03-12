import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:voci_app/features/requests/data/models/request.dart';
import 'package:voci_app/core/errors/firestore_errors.dart';
import 'package:voci_app/core/errors/core_errors.dart';

class RequestsFirestoreDatasource {
  final FirebaseFirestore _firestore;

  RequestsFirestoreDatasource({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  // Collection and batch size
  static const String _collectionName = 'requests';
  static const int _batchSize = 15;

  // Status constants
  static const String _todoStatus = 'TODO';
  static const String _doneStatus = 'DONE';

  // Get Active (TO DO) Requests
  Future<(List<Request>, DocumentSnapshot?)> getActiveRequests(
      {DocumentSnapshot? lastDocument}) async {
    return _getRequestsByStatus(
        status: _todoStatus, lastDocument: lastDocument);
  }

  // Get Completed (DONE) Requests
  Future<(List<Request>, DocumentSnapshot?)> getCompletedRequests(
      {DocumentSnapshot? lastDocument}) async {
    return _getRequestsByStatus(
        status: _doneStatus, lastDocument: lastDocument);
  }

  // Generic method to get requests by status
  Future<(List<Request>, DocumentSnapshot?)> _getRequestsByStatus(
      {required String status, DocumentSnapshot? lastDocument}) async {

    Query<Request> query = _firestore
        .collection(_collectionName)
        .withConverter(
      fromFirestore: Request.fromFirestore,
      toFirestore: (Request request, _) => request.toMap(),
    )
        .where('status', isEqualTo: status)
        .orderBy('timestamp', descending: true)
        .limit(_batchSize);


    if (lastDocument != null) {
      query = query.startAfterDocument(lastDocument);
    }
    try {
      final querySnapshot = await query.get();

      final requestsList = querySnapshot.docs.map((doc) => doc.data()).toList();

      DocumentSnapshot? newLastDocument;
      if (requestsList.isNotEmpty) {
        newLastDocument = querySnapshot.docs.last;
      } else {
      }

      return (requestsList, newLastDocument);
    } on FirebaseException catch (e) {
      throw FirestoreError(message: 'Firebase exception: ${e.message}');
    } catch (e) {
      throw UnexpectedError(message: 'Unexpected error: ${e.toString()}');
    }
  }

  Future<DocumentSnapshot?> getLastVisibleDocument(
      {String status = _todoStatus, DocumentSnapshot? lastDocument}) async {
    Query<Request> query = _firestore
        .collection(_collectionName)
        .withConverter(
      fromFirestore: Request.fromFirestore,
      toFirestore: (Request request, _) => request.toMap(),
    )
        .where('status', isEqualTo: status)
        .orderBy('timestamp', descending: true)
        .limit(_batchSize);
    if (lastDocument != null) {
      query = query.startAfterDocument(lastDocument);
    }
    try {
      final querySnapshot = await query.get();
      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.last;
      }
      return null;
    } on FirebaseException catch (e) {
      throw FirestoreError(message: 'Firebase exception: ${e.message}');
    } catch (e) {
      throw UnexpectedError(message: 'Unexpected error: ${e.toString()}');
    }
  }
}