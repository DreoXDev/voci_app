import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:voci_app/features/homeless/data/models/homeless.dart';

class HomelessFirestoreDatasource {
  final FirebaseFirestore _firestore;

  HomelessFirestoreDatasource({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  // This is the name of the collection in Firestore
  static const String _collectionName = 'homelesses';
  static const int _batchSize = 15;

  Future<List<Homeless>> getHomelessList({DocumentSnapshot? lastDocument}) async {
    print('getHomelessList: Started, lastDocument: $lastDocument');
    Query<Homeless> query = _firestore
        .collection(_collectionName)
        .withConverter(
      fromFirestore: Homeless.fromFirestore,
      toFirestore: (Homeless homeless, _) => homeless.toMap(),
    )
        .orderBy(FieldPath.documentId) //Important for pagination consistency
        .limit(_batchSize);
    print('getHomelessList: Base query created');

    // If a last document is provided, start after that document
    if (lastDocument != null) {
      print('getHomelessList: Applying startAfterDocument');
      query = query.startAfterDocument(lastDocument);
    }

    print('getHomelessList: Getting querySnapshot');
    final querySnapshot = await query.get();
    print('getHomelessList: Got querySnapshot with ${querySnapshot.docs.length} documents');

    print('getHomelessList: Mapping documents to Homeless objects');
    final homelessList = querySnapshot.docs.map((doc) => doc.data()).toList();
    print('getHomelessList: Returning ${homelessList.length} Homeless objects');

    return homelessList;
  }

  Future<(List<Homeless>, DocumentSnapshot?)> searchHomeless(
      {required String searchQuery, DocumentSnapshot? lastDocument}) async {
    print('searchHomeless: Started, searchQuery: $searchQuery, lastDocument: $lastDocument');

    if (searchQuery.isEmpty) {
      print('searchHomeless: searchQuery is empty, returning empty list');
      return (<Homeless>[], null);
    }
    print('searchHomeless: Creating base query');
    Query<Homeless> query = _firestore
        .collection(_collectionName)
        .withConverter(
      fromFirestore: Homeless.fromFirestore,
      toFirestore: (Homeless homeless, _) => homeless.toMap(),
    );

    print('searchHomeless: Base query created');
    print('searchHomeless: Creating where clauses');

    query = query
        .where('name', isGreaterThanOrEqualTo: searchQuery)
        .where('name', isLessThan: '${searchQuery}z');

    print('searchHomeless: Where clauses created');

    query = query
        .orderBy('name') // Assuming you want to sort results by name
        .limit(_batchSize);

    print('searchHomeless: Query with orderby and limit created');
    // The problem was this, when searching we can not use the last document
    //if (lastDocument != null) {
    //  print('searchHomeless: Applying startAfterDocument');
    //  query = query.startAfterDocument(lastDocument);
    //}

    print('searchHomeless: Getting querySnapshot');
    final querySnapshot = await query.get();
    print('searchHomeless: Got querySnapshot with ${querySnapshot.docs.length} documents');

    print('searchHomeless: Mapping documents to Homeless objects');
    final homelessList = querySnapshot.docs.map((doc) => doc.data()).toList();
    print('searchHomeless: Mapped documents, found ${homelessList.length} Homeless objects');

    DocumentSnapshot? newLastDocument;
    if(homelessList.isNotEmpty){
      print('searchHomeless: Setting newLastDocument to last document');
      newLastDocument = querySnapshot.docs.last;
    }else {
      print('searchHomeless: List is empty, newLastDocument will be null');
    }
    print('searchHomeless: Returning results');

    return (homelessList, newLastDocument);
  }

  Future<DocumentSnapshot?> getLastVisibleDocument({DocumentSnapshot? lastDocument}) async {
    print('getLastVisibleDocument: Started');
    Query<Homeless> query = _firestore
        .collection(_collectionName)
        .withConverter(
      fromFirestore: Homeless.fromFirestore,
      toFirestore: (Homeless homeless, _) => homeless.toMap(),
    )
        .orderBy(FieldPath.documentId) //Important for pagination consistency
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