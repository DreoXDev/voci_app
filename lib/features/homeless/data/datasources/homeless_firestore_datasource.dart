import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:voci_app/features/homeless/data/models/homeless.dart';

class HomelessFirestoreDatasource {
  final FirebaseFirestore _firestore;

  HomelessFirestoreDatasource({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  // This is the name of the collection in firestore
  static const String _collectionName = 'homelesses';

  Future<List<Homeless>> getHomelessList() async {
    final querySnapshot = await _firestore
        .collection(_collectionName)
        .withConverter(
      fromFirestore: Homeless.fromFirestore,
      toFirestore: (Homeless homeless, _) => homeless.toMap(),
    )
        .get();
    return querySnapshot.docs.map((doc) => doc.data()).toList();
  }
}