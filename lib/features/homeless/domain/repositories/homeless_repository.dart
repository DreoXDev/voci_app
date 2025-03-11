import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:voci_app/features/homeless/domain/entities/homeless_entity.dart';

abstract class HomelessRepository {
  Future<List<HomelessEntity>> getHomelessList({DocumentSnapshot? lastDocument});
  Future<DocumentSnapshot?> getLastVisibleDocument({DocumentSnapshot? lastDocument});

}