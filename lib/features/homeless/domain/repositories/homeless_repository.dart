import 'package:voci_app/features/homeless/domain/entities/homeless_entity.dart';

abstract class HomelessRepository {
  Future<List<HomelessEntity>> getHomelessList();
}