import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voci_app/features/homeless/domain/entities/homeless_entity.dart';
import 'package:voci_app/features/homeless/presentation/controllers/homeless_controller.dart';
import 'package:voci_app/core/providers.dart';

final homelessControllerProvider = StateNotifierProvider<HomelessController, AsyncValue<List<HomelessEntity>>>(
      (ref) => HomelessController(
    ref.watch(homelessRepositoryProvider),
  )..getHomelessList(), // Fetch the data when the controller is created
);