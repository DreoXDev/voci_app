import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:voci_app/features/homeless/data/models/homeless.dart';

class HomelessFirestoreDatasource {
  final FirebaseFirestore _firestore;

  HomelessFirestoreDatasource({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  static const String _collectionName = 'homelesses';
  static const int _batchSize = 15;

  Future<List<Homeless>> getHomelessList(
      {DocumentSnapshot? lastDocument}) async {
    print('getHomelessList: Started, lastDocument: $lastDocument');
    Query<Homeless> query = _firestore
        .collection(_collectionName)
        .withConverter(
          fromFirestore: Homeless.fromFirestore,
          toFirestore: (Homeless homeless, _) => homeless.toMap(),
        )
        .limit(_batchSize);
    print('getHomelessList: Base query created');

    if (lastDocument != null) {
      print('getHomelessList: Applying startAfterDocument');
      query = query.startAfterDocument(lastDocument);
    }

    print('getHomelessList: Getting querySnapshot');
    final querySnapshot = await query.get();
    print(
        'getHomelessList: Got querySnapshot with ${querySnapshot.docs.length} documents');

    print('getHomelessList: Mapping documents to Homeless objects');
    final homelessList = querySnapshot.docs.map((doc) => doc.data()).toList();
    print(
        'getHomelessList: Mapped documents, found ${homelessList.length} Homeless objects');

    return homelessList;
  }

  Future<(List<Homeless>, DocumentSnapshot?)> searchHomeless(
      {required String searchQuery, DocumentSnapshot? lastDocument}) async {
    print(
        'searchHomeless: Started, searchQuery: $searchQuery, lastDocument: $lastDocument');

    Query<Homeless> query = _firestore
        .collection(_collectionName)
        .withConverter(
          fromFirestore: Homeless.fromFirestore,
          toFirestore: (Homeless homeless, _) => homeless.toMap(),
        )
        .orderBy('name')
        .where('name', isGreaterThanOrEqualTo: searchQuery)
        .where('name', isLessThan: '${searchQuery}z')
        .limit(_batchSize);

    print('searchHomeless: Base query created');

    print('searchHomeless: Getting querySnapshot');
    final querySnapshot = await query.get();
    print(
        'searchHomeless: Got querySnapshot with ${querySnapshot.docs.length} documents');

    print('searchHomeless: Mapping documents to Homeless objects');
    final homelessList = querySnapshot.docs.map((doc) => doc.data()).toList();
    print(
        'searchHomeless: Mapped documents, found ${homelessList.length} Homeless objects');
    DocumentSnapshot? newLastDocument;
    if (homelessList.isNotEmpty) {
      print('searchHomeless: Setting newLastDocument to last document');
      newLastDocument = querySnapshot.docs.last;
    } else {
      print('searchHomeless: List is empty, newLastDocument will be null');
    }
    print('searchHomeless: Returning results');
    return (homelessList, newLastDocument);
  }

  Future<DocumentSnapshot?> getLastVisibleDocument(
      {DocumentSnapshot? lastDocument}) async {
    print('getLastVisibleDocument: Started');
    Query<Homeless> query = _firestore
        .collection(_collectionName)
        .withConverter(
          fromFirestore: Homeless.fromFirestore,
          toFirestore: (Homeless homeless, _) => homeless.toMap(),
        )
        .limit(_batchSize);
    print('getLastVisibleDocument: Base query created');
    if (lastDocument != null) {
      print('getLastVisibleDocument: Applying startAfterDocument');
      query = query.startAfterDocument(lastDocument);
    }
    print('getLastVisibleDocument: Getting querySnapshot');
    final querySnapshot = await query.get();
    print(
        'getLastVisibleDocument: Got querySnapshot with ${querySnapshot.docs.length} documents');
    if (querySnapshot.docs.isNotEmpty) {
      print('getLastVisibleDocument: Returning last document');
      return querySnapshot.docs.last;
    }
    print('getLastVisibleDocument: No documents, returning null');
    return null;
  }

  Future<Map<String, String>> getHomelessNames(
      {required Set<String> homelessIds}) async {
    print('getHomelessNames: Started, homelessIds: $homelessIds');
    if (homelessIds.isEmpty) {
      print('getHomelessNames: No homeless IDs provided, returning empty map.');
      return {};
    }
    final query = _firestore
        .collection(_collectionName)
        .where('id', whereIn: homelessIds)
        .withConverter(
            fromFirestore: Homeless.fromFirestore,
            toFirestore: (Homeless homeless, _) => homeless.toMap());
    print('getHomelessNames: Getting querySnapshot');
    final querySnapshot = await query.get();
    print(
        'getHomelessNames: Got querySnapshot with ${querySnapshot.docs.length} documents');

    final namesMap = <String, String>{};
    for (final doc in querySnapshot.docs) {
      final homeless = doc.data();
      namesMap[homeless.id] = homeless.name;
    }
    print('getHomelessNames: returning $namesMap');
    return namesMap;
  }

  Future<Homeless> getHomelessById({required String homelessId}) async {
    print('getHomelessById: Started, homelessId: $homelessId');
    final query = _firestore
        .collection(_collectionName)
        .where('id', isEqualTo: homelessId)
        .withConverter(
            fromFirestore: Homeless.fromFirestore,
            toFirestore: (Homeless homeless, _) => homeless.toMap());
    print('getHomelessById: Getting querySnapshot');
    final querySnapshot = await query.get();
    print(
        'getHomelessById: Got querySnapshot with ${querySnapshot.docs.length} documents'); // <-- Corrected!

    if (querySnapshot.docs.isEmpty) {
      print('getHomelessById: Document does not exist');
      throw Exception('Homeless with id $homelessId not found');
    }
    final homeless = querySnapshot.docs.first.data();
    print('getHomelessById: returning $homeless');
    return homeless;
  }
}
