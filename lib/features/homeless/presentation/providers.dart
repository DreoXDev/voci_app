import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fuzzywuzzy/fuzzywuzzy.dart';
import 'package:fuzzywuzzy/model/extracted_result.dart';
import 'package:voci_app/features/homeless/domain/entities/homeless_entity.dart';
import 'package:voci_app/features/homeless/domain/providers.dart';
import 'package:voci_app/features/homeless/presentation/controllers/homeless_controller.dart';

final homelessControllerProvider = StateNotifierProvider<HomelessController, HomelessState>(
      (ref) => HomelessController(
    ref.watch(getHomelessProvider),
  ),
);

// 4. Create the query
final searchQueryProvider = StateProvider<String>((ref) {
  print('providers: searchQueryProvider is being evaluated');
  return '';
});

// 5. Filter the list using the query
final filteredHomelessListProvider = FutureProvider<List<HomelessEntity>>((ref) async {
  print('providers: filteredHomelessListProvider is being evaluated');
  final searchQuery = ref.watch(searchQueryProvider);
  //This was changed because the controller has the data, it will be listened there
  final homelessList = ref.watch(homelessControllerProvider).data;

  if (searchQuery.length < 2) {
    return homelessList; // Don't filter if the query is too short
  } else {
    // Create a list of all strings to search
    final allStringsToSearch = homelessList.map((homeless) => [
      homeless.name.toLowerCase(),
      homeless.gender.toLowerCase(),
      homeless.location.toLowerCase(),
      homeless.nationality.toLowerCase()
    ]).expand((element) => element).toList();
    // Extract the strings that are similar to the query
    final List<ExtractedResult<String>> extracted = extractAll(
      query: searchQuery.toLowerCase(),
      choices: allStringsToSearch,
      cutoff: 70,
    );
    // Create a list of strings that have a score over 70
    final similarStrings = extracted.map((e) => e.choice).toList();
    // Return the ones that are similar
    return homelessList
        .where((element) =>
    similarStrings.contains(element.name.toLowerCase()) ||
        similarStrings.contains(element.gender.toLowerCase()) ||
        similarStrings.contains(element.location.toLowerCase()) ||
        similarStrings.contains(element.nationality.toLowerCase()))
        .toList();
  }
});