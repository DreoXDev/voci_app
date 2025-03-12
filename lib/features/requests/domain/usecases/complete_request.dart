import '../../../../core/usecase/usecase.dart';
import '../../data/models/request.dart';
import '../repositories/request_repository.dart';

class CompleteRequest implements UseCase<void, CompleteRequestParams> {
  final RequestRepository repository;

  CompleteRequest(this.repository);

  @override
  Future<void> call(CompleteRequestParams params) async {
    return await repository.updateRequestStatus(
      requestId: params.requestId,
      status: RequestStatus.done,
    );
  }
}

class CompleteRequestParams {
  final String requestId;

  CompleteRequestParams({required this.requestId});
}