import 'package:voci_app/core/usecase/usecase.dart';
import 'package:voci_app/features/homeless/domain/entities/homeless_entity.dart';
import 'package:voci_app/features/homeless/domain/repositories/homeless_repository.dart';

class GetHomeless implements UseCase<List<HomelessEntity>, NoParams> {
  final HomelessRepository repository;

  GetHomeless(this.repository);

  @override
  Future<List<HomelessEntity>> call(NoParams params) {
    return repository.getHomelessList();
  }
}