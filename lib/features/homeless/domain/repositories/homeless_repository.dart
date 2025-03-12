import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:voci_app/features/homeless/domain/entities/homeless_entity.dart';

abstract class HomelessRepository {
  Future<List<HomelessEntity>> getHomelessList(
      {DocumentSnapshot? lastDocument});

  Future<(List<HomelessEntity>, DocumentSnapshot?)> searchHomeless(
      {required String searchQuery, DocumentSnapshot? lastDocument});

  Future<DocumentSnapshot?> getLastVisibleDocument(
      {required DocumentSnapshot? lastDocument});

  Future<void> getHomelessNames({required Set<String> homelessIds});

  Future<HomelessEntity> getHomelessById({required String homelessId});
}
