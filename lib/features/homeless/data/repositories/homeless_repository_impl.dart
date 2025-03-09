import 'package:voci_app/features/homeless/data/datasources/homeless_firestore_datasource.dart';
import 'package:voci_app/features/homeless/domain/entities/homeless_entity.dart';
import 'package:voci_app/features/homeless/domain/repositories/homeless_repository.dart';

class HomelessRepositoryImpl implements HomelessRepository {
  final HomelessFirestoreDatasource _datasource;

  HomelessRepositoryImpl(this._datasource);

  @override
  Future<List<HomelessEntity>> getHomelessList() async {
    final list = await _datasource.getHomelessList();
    return list.map((e) => e.toEntity()).toList();
  }
}