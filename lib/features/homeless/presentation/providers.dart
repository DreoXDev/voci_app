import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voci_app/features/homeless/data/providers.dart';
import 'package:voci_app/features/homeless/domain/usecases/get_homeless.dart';
import 'package:voci_app/features/homeless/domain/usecases/search_homeless.dart';
import 'package:voci_app/features/homeless/presentation/controllers/homeless_controller.dart';

final getHomelessProvider = Provider<GetHomeless>((ref) {
  final homelessRepository = ref.watch(homelessRepositoryProvider);
  return GetHomeless(homelessRepository);
});

final searchHomelessProvider = Provider<SearchHomeless>((ref) {
  final homelessRepository = ref.watch(homelessRepositoryProvider);
  return SearchHomeless(homelessRepository);
});

final homelessControllerProvider = StateNotifierProvider<HomelessController, HomelessState>(
      (ref) => HomelessController(
      ref.watch(getHomelessProvider),
      ref.watch(searchHomelessProvider)
  ),
);

final searchQueryProvider = StateProvider<String>((ref) => "");