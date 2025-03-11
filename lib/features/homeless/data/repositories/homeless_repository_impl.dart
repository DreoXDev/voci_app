import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:voci_app/features/homeless/data/datasources/homeless_firestore_datasource.dart';
import 'package:voci_app/features/homeless/domain/entities/homeless_entity.dart';
import 'package:voci_app/features/homeless/domain/repositories/homeless_repository.dart';

class HomelessRepositoryImpl implements HomelessRepository {
  final HomelessFirestoreDatasource _datasource;

  HomelessRepositoryImpl(this._datasource);

  @override
  Future<List<HomelessEntity>> getHomelessList({DocumentSnapshot? lastDocument}) async {
    final list = await _datasource.getHomelessList(lastDocument: lastDocument);
    return list.map((e) => e.toEntity()).toList();
  }
  @override
  Future<DocumentSnapshot?> getLastVisibleDocument({DocumentSnapshot? lastDocument}) async {
    return await _datasource.getLastVisibleDocument(lastDocument: lastDocument);
  }
}