import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:voci_app/core/usecase/usecase.dart';
import 'package:voci_app/features/homeless/domain/entities/homeless_entity.dart';
import 'package:voci_app/features/homeless/domain/repositories/homeless_repository.dart';

class GetHomeless implements UseCase<List<HomelessEntity>, GetHomelessParams> {
  final HomelessRepository repository;

  GetHomeless(this.repository);

  @override
  Future<List<HomelessEntity>> call(GetHomelessParams params) async {
    return await repository.getHomelessList(lastDocument: params.lastDocument);
  }
}

class GetHomelessParams {
  final DocumentSnapshot? lastDocument;

  GetHomelessParams({this.lastDocument});
}