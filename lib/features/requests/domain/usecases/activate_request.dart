import '../../../../core/usecase/usecase.dart';
import '../../data/models/request.dart';
import '../repositories/request_repository.dart';

class ActivateRequest implements UseCase<void, ActivateRequestParams> {
  final RequestRepository repository;

  ActivateRequest(this.repository);

  @override
  Future<void> call(ActivateRequestParams params) async {
    return await repository.updateRequestStatus(
      requestId: params.requestId,
      status: RequestStatus.todo,
    );
  }
}

class ActivateRequestParams {
  final String requestId;

  ActivateRequestParams({required this.requestId});
}