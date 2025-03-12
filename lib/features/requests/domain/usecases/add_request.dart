import '../../../../core/usecase/usecase.dart';
import '../entities/request_entity.dart';
import '../repositories/request_repository.dart';

class AddRequest implements UseCase<String, AddRequestParams> {
  final RequestRepository repository;

  AddRequest(this.repository);

  @override
  Future<String> call(AddRequestParams params) async {
    return await repository.addRequest(request: params.request);
  }
}

class AddRequestParams {
  final RequestEntity request;

  AddRequestParams({required this.request});
}