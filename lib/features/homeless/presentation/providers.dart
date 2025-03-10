import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fuzzywuzzy/model/extracted_result.dart';
import 'package:voci_app/features/homeless/domain/entities/homeless_entity.dart';
import 'package:voci_app/features/homeless/domain/usecases/get_homeless.dart';
import 'package:voci_app/features/homeless/domain/repositories/homeless_repository.dart';
import 'package:voci_app/core/usecase/usecase.dart';
import 'package:fuzzywuzzy/fuzzywuzzy.dart';

// 1. Create the repository
// We don't watch anything, this provider will be overridden.
final homelessRepositoryProvider = Provider<HomelessRepository>((ref) {
  print('providers: homelessRepositoryProvider is being evaluated');
  return throw UnimplementedError();
});

// 2. Create the use case and pass the repository as a parameter
// Get the correct implementation when this provider is being watched
final getHomelessProvider = Provider((ref) {
  print('providers: getHomelessProvider is being evaluated');
  return GetHomeless(ref.read(homelessRepositoryProvider));
});

// 3. Get the data using the use case
final homelessListProvider = Provider<Future<List<HomelessEntity>>>((ref) async {
  print('providers: homelessListProvider is being evaluated');
  final getHomeless = ref.watch(getHomelessProvider);
  return getHomeless(NoParams());
});

// 4. Create the query
final searchQueryProvider = StateProvider<String>((ref) {
  print('providers: searchQueryProvider is being evaluated');
  return '';
});

// 5. Filter the list using the query
final filteredHomelessListProvider = FutureProvider<List<HomelessEntity>>((ref) async {
  print('providers: filteredHomelessListProvider is being evaluated');
  final searchQuery = ref.watch(searchQueryProvider);
  final homelessListFuture = ref.watch(homelessListProvider);
  final homelessList = await homelessListFuture;

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
        cutoff: 70
    );
    // Create a list of strings that have a score over 70
    final similarStrings = extracted.map((e) => e.choice).toList();
    // Return the ones that are similar
    return homelessList.where((element) => similarStrings.contains(element.name.toLowerCase()) ||
        similarStrings.contains(element.gender.toLowerCase()) ||
        similarStrings.contains(element.location.toLowerCase()) ||
        similarStrings.contains(element.nationality.toLowerCase())
    ).toList();
  }
});