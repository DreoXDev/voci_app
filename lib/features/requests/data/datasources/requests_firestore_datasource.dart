import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:voci_app/features/requests/data/models/request.dart';

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
  Future<(List<Request>, DocumentSnapshot?)> getActiveRequests({DocumentSnapshot? lastDocument}) async {
    return _getRequestsByStatus(status: _todoStatus, lastDocument: lastDocument);
  }

  // Get Completed (DONE) Requests
  Future<(List<Request>, DocumentSnapshot?)> getCompletedRequests({DocumentSnapshot? lastDocument}) async {
    return _getRequestsByStatus(status: _doneStatus, lastDocument: lastDocument);
  }

  // Generic method to get requests by status
  Future<(List<Request>, DocumentSnapshot?)> _getRequestsByStatus(
      {required String status, DocumentSnapshot? lastDocument}) async {
    print('getRequestsByStatus: Started, status: $status, lastDocument: $lastDocument');

    Query<Request> query = _firestore
        .collection(_collectionName)
        .withConverter(
      fromFirestore: Request.fromFirestore,
      toFirestore: (Request request, _) => request.toMap(),
    )
        .where('status', isEqualTo: status) // Filter by status
        .orderBy('timestamp', descending: true) //Order by the most recient one
        .limit(_batchSize);

    print('getRequestsByStatus: Base query created');

    if (lastDocument != null) {
      print('getRequestsByStatus: Applying startAfterDocument');
      query = query.startAfterDocument(lastDocument);
    }

    print('getRequestsByStatus: Getting querySnapshot');
    final querySnapshot = await query.get();
    print('getRequestsByStatus: Got querySnapshot with ${querySnapshot.docs.length} documents');

    print('getRequestsByStatus: Mapping documents to Request objects');
    final requestsList = querySnapshot.docs.map((doc) => doc.data()).toList();
    print('getRequestsByStatus: Mapped documents, found ${requestsList.length} Request objects');

    DocumentSnapshot? newLastDocument;
    if(requestsList.isNotEmpty){
      print('getRequestsByStatus: Setting newLastDocument to last document');
      newLastDocument = querySnapshot.docs.last;
    }else {
      print('getRequestsByStatus: List is empty, newLastDocument will be null');
    }
    print('getRequestsByStatus: Returning results');

    return (requestsList, newLastDocument);
  }

  Future<DocumentSnapshot?> getLastVisibleDocument({String status = _todoStatus, DocumentSnapshot? lastDocument}) async {
    print('getLastVisibleDocument: Started');
    Query<Request> query = _firestore
        .collection(_collectionName)
        .withConverter(
      fromFirestore: Request.fromFirestore,
      toFirestore: (Request request, _) => request.toMap(),
    ).where('status', isEqualTo: status)
        .orderBy('timestamp', descending: true)
        .limit(_batchSize);
    print('getLastVisibleDocument: Base query created');
    if (lastDocument != null) {
      print('getLastVisibleDocument: Applying startAfterDocument');
      query = query.startAfterDocument(lastDocument);
    }
    print('getLastVisibleDocument: Getting querySnapshot');
    final querySnapshot = await query.get();
    print('getLastVisibleDocument: Got querySnapshot with ${querySnapshot.docs.length} documents');
    if (querySnapshot.docs.isNotEmpty) {
      print('getLastVisibleDocument: Returning last document');
      return querySnapshot.docs.last;
    }
    print('getLastVisibleDocument: No documents, returning null');
    return null;
  }
}