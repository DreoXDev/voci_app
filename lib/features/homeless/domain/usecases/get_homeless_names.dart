import 'package:voci_app/core/usecase/usecase.dart';
import 'package:voci_app/features/homeless/domain/repositories/homeless_repository.dart';

class GetHomelessNames implements UseCase<void, GetHomelessNamesParams> {
  final HomelessRepository repository;

  GetHomelessNames(this.repository);

  @override
  Future<void> call(GetHomelessNamesParams params) async {
    await repository.getHomelessNames(homelessIds: params.homelessIds);
  }
}

class GetHomelessNamesParams {
  final Set<String> homelessIds;

  GetHomelessNamesParams({required this.homelessIds});
}