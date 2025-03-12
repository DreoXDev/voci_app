import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:voci_app/core/usecase/usecase.dart';
import 'package:voci_app/features/homeless/domain/entities/homeless_entity.dart';
import 'package:voci_app/features/homeless/domain/repositories/homeless_repository.dart';

class SearchHomeless
    implements
        UseCase<(List<HomelessEntity>, DocumentSnapshot?),
            SearchHomelessParams> {
  final HomelessRepository _repository;

  SearchHomeless(this._repository);

  @override
  Future<(List<HomelessEntity>, DocumentSnapshot?)> call(
      SearchHomelessParams params) async {
    return await _repository.searchHomeless(
        searchQuery: params.searchQuery, lastDocument: params.lastDocument);
  }
}

class SearchHomelessParams {
  final String searchQuery;
  final DocumentSnapshot? lastDocument;

  SearchHomelessParams({required this.searchQuery, this.lastDocument});
}
