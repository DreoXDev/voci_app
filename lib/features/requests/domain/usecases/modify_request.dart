import '../../../../core/usecase/usecase.dart';
import '../repositories/request_repository.dart';

class ModifyRequest implements UseCase<void, ModifyRequestParams> {
  final RequestRepository repository;

  ModifyRequest(this.repository);

  @override
  Future<void> call(ModifyRequestParams params) async {
    return await repository.modifyRequest(
      requestId: params.requestId,
      updates: params.updates,
    );
  }
}

class ModifyRequestParams {
  final String requestId;
  final Map<String, dynamic> updates;

  ModifyRequestParams({required this.requestId, required this.updates});
}