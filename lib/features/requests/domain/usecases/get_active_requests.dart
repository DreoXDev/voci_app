import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:voci_app/core/usecase/usecase.dart';
import 'package:voci_app/features/requests/domain/entities/request_entity.dart';
import 'package:voci_app/features/requests/domain/repositories/request_repository.dart';

class GetActiveRequests implements UseCase<(List<RequestEntity>, DocumentSnapshot?), GetActiveRequestsParams> {
  final RequestRepository repository;

  GetActiveRequests(this.repository);

  @override
  Future<(List<RequestEntity>, DocumentSnapshot?)> call(GetActiveRequestsParams params) async {
    return await repository.getActiveRequests(lastDocument: params.lastDocument);
  }
}

class GetActiveRequestsParams {
  final DocumentSnapshot? lastDocument;

  GetActiveRequestsParams({this.lastDocument});
}