import '../../../../core/usecase/usecase.dart';
import '../repositories/request_repository.dart';

class DeleteRequest implements UseCase<void, DeleteRequestParams> {
  final RequestRepository repository;

  DeleteRequest(this.repository);

  @override
  Future<void> call(DeleteRequestParams params) async {
    return await repository.deleteRequest(requestId: params.requestId);
  }
}

class DeleteRequestParams {
  final String requestId;

  DeleteRequestParams({required this.requestId});
}