import 'package:voci_app/core/usecase/usecase.dart';
import 'package:voci_app/features/homeless/domain/entities/homeless_entity.dart';
import 'package:voci_app/features/homeless/domain/repositories/homeless_repository.dart';

class GetHomelessById
    implements UseCase<HomelessEntity, GetHomelessByIdParams> {
  final HomelessRepository repository;

  GetHomelessById(this.repository);

  @override
  Future<HomelessEntity> call(GetHomelessByIdParams params) async {
    return await repository.getHomelessById(homelessId: params.homelessId);
  }
}

class GetHomelessByIdParams {
  final String homelessId;

  GetHomelessByIdParams({required this.homelessId});
}
