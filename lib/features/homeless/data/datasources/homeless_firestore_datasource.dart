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
    Query<Homeless> query = _firestore
        .collection(_collectionName)
        .withConverter(
          fromFirestore: Homeless.fromFirestore,
          toFirestore: (Homeless homeless, _) => homeless.toMap(),
        )
        .orderBy(FieldPath.documentId) //Important for pagination consistency
        .limit(_batchSize);

    // If a last document is provided, start after that document
    if (lastDocument != null) {
      query = query.startAfterDocument(lastDocument);
    }

    final querySnapshot = await query.get();

    return querySnapshot.docs.map((doc) => doc.data()).toList();
  }

  Future<DocumentSnapshot?> getLastVisibleDocument({DocumentSnapshot? lastDocument}) async {
    Query<Homeless> query = _firestore
        .collection(_collectionName)
        .withConverter(
          fromFirestore: Homeless.fromFirestore,
          toFirestore: (Homeless homeless, _) => homeless.toMap(),
        )
        .orderBy(FieldPath.documentId) //Important for pagination consistency
        .limit(_batchSize);
    if (lastDocument != null) {
      query = query.startAfterDocument(lastDocument);
    }
    final querySnapshot = await query.get();
    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs.last;
    }
    return null;
  }
}