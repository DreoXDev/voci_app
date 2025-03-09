import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voci_app/features/homeless/domain/entities/homeless_entity.dart';
import 'package:voci_app/features/homeless/domain/repositories/homeless_repository.dart';

class HomelessController extends StateNotifier<AsyncValue<List<HomelessEntity>>> {
  final HomelessRepository _repository;

  HomelessController(this._repository) : super(const AsyncLoading());

  Future<void> getHomelessList() async {
    state = const AsyncLoading();
    try {
      final homelessList = await _repository.getHomelessList();
      state = AsyncData(homelessList);
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
    }
  }
}