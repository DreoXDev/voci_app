import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:voci_app/core/usecase/usecase.dart';
import 'package:voci_app/features/requests/domain/entities/request_entity.dart';
import 'package:voci_app/features/requests/domain/repositories/request_repository.dart';

class GetCompletedRequests
    implements
        UseCase<(List<RequestEntity>, DocumentSnapshot?),
            GetCompletedRequestsParams> {
  final RequestRepository repository;

  GetCompletedRequests(this.repository);

  @override
  Future<(List<RequestEntity>, DocumentSnapshot?)> call(
      GetCompletedRequestsParams params) async {
    return await repository.getCompletedRequests(
        lastDocument: params.lastDocument);
  }
}

class GetCompletedRequestsParams {
  final DocumentSnapshot? lastDocument;

  GetCompletedRequestsParams({this.lastDocument});
}