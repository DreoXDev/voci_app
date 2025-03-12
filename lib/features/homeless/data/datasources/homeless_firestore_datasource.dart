import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:voci_app/features/homeless/data/models/homeless.dart';
import 'package:voci_app/core/errors/core_errors.dart';
import '../../../../core/errors/firestore_errors.dart';

class HomelessFirestoreDatasource {
  final FirebaseFirestore _firestore;

  HomelessFirestoreDatasource({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  static const String _collectionName = 'homelesses';
  static const int _batchSize = 15;

  Future<List<Homeless>> getHomelessList(
      {DocumentSnapshot? lastDocument}) async {
    Query<Homeless> query = _firestore
        .collection(_collectionName)
        .withConverter(
      fromFirestore: Homeless.fromFirestore,
      toFirestore: (Homeless homeless, _) => homeless.toMap(),
    )
        .limit(_batchSize);

    if (lastDocument != null) {
      query = query.startAfterDocument(lastDocument);
    }
    try {
      final querySnapshot = await query.get();

      final homelessList = querySnapshot.docs.map((doc) => doc.data()).toList();

      return homelessList;
    } on FirebaseException catch (e) {
      throw FirestoreError(message: 'Firebase exception: ${e.message}');
    } catch (e) {
      throw UnexpectedError(message: 'Unexpected error: ${e.toString()}');
    }
  }

  Future<(List<Homeless>, DocumentSnapshot?)> searchHomeless(
      {required String searchQuery, DocumentSnapshot? lastDocument}) async {
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

    try {
      final querySnapshot = await query.get();

      final homelessList = querySnapshot.docs.map((doc) => doc.data()).toList();
      DocumentSnapshot? newLastDocument;
      if (homelessList.isNotEmpty) {
        newLastDocument = querySnapshot.docs.last;
      }
      return (homelessList, newLastDocument);
    } on FirebaseException catch (e) {
      throw FirestoreError(message: 'Firebase exception: ${e.message}');
    } catch (e) {
      throw UnexpectedError(message: 'Unexpected error: ${e.toString()}');
    }
  }

  Future<DocumentSnapshot?> getLastVisibleDocument(
      {DocumentSnapshot? lastDocument}) async {
    Query<Homeless> query = _firestore
        .collection(_collectionName)
        .withConverter(
      fromFirestore: Homeless.fromFirestore,
      toFirestore: (Homeless homeless, _) => homeless.toMap(),
    )
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

  Future<Map<String, String>> getHomelessNames(
      {required Set<String> homelessIds}) async {
    if (homelessIds.isEmpty) {
      return {};
    }
    final query = _firestore
        .collection(_collectionName)
        .where('id', whereIn: homelessIds)
        .withConverter(
        fromFirestore: Homeless.fromFirestore,
        toFirestore: (Homeless homeless, _) => homeless.toMap());
    try {
      final querySnapshot = await query.get();

      final namesMap = <String, String>{};
      for (final doc in querySnapshot.docs) {
        final homeless = doc.data();
        namesMap[homeless.id] = homeless.name;
      }
      return namesMap;
    } on FirebaseException catch (e) {
      throw FirestoreError(message: 'Firebase exception: ${e.message}');
    } catch (e) {
      throw UnexpectedError(message: 'Unexpected error: ${e.toString()}');
    }
  }

  Future<Homeless> getHomelessById({required String homelessId}) async {
    final query = _firestore
        .collection(_collectionName)
        .where('id', isEqualTo: homelessId)
        .withConverter(
        fromFirestore: Homeless.fromFirestore,
        toFirestore: (Homeless homeless, _) => homeless.toMap());
    try {
      final querySnapshot = await query.get();

      if (querySnapshot.docs.isEmpty) {
        throw DocumentNotFoundError(documentId: homelessId);
      }
      final homeless = querySnapshot.docs.first.data();
      return homeless;
    } on FirebaseException catch (e) {
      throw FirestoreError(message: 'Firebase exception: ${e.message}');
    } catch (e) {
      throw UnexpectedError(message: 'Unexpected error: ${e.toString()}');
    }
  }
}