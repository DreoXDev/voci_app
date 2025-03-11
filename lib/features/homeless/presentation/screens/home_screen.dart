import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fuzzywuzzy/fuzzywuzzy.dart';
import 'package:fuzzywuzzy/model/extracted_result.dart';
import 'package:voci_app/features/homeless/domain/entities/homeless_entity.dart';
import 'package:voci_app/features/homeless/presentation/controllers/homeless_controller.dart';
import 'package:voci_app/features/homeless/presentation/providers.dart';
import 'package:voci_app/features/homeless/presentation/widgets/home_app_bar.dart';
import 'package:voci_app/features/homeless/presentation/widgets/homeless_list_item.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(homelessControllerProvider.notifier).getHomelessList());
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      ref.read(homelessControllerProvider.notifier).getHomelessList();
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    final homelessState = ref.watch(homelessControllerProvider);
    final String searchQuery = ref.watch(searchQueryProvider);
    final List<HomelessEntity> data = homelessState.data;
    List<HomelessEntity> filteredData = [];

    if (searchQuery.length < 2) {
      filteredData = data;
    } else {
      final allStringsToSearch = data
          .map((homeless) => [
        homeless.name.toLowerCase(),
        homeless.gender.toLowerCase(),
        homeless.location.toLowerCase(),
        homeless.nationality.toLowerCase()
      ])
          .expand((element) => element)
          .toList();

      final List<ExtractedResult<String>> extracted = extractAll(
        query: searchQuery.toLowerCase(),
        choices: allStringsToSearch,
        cutoff: 70,
      );

      final similarStrings = extracted.map((e) => e.choice).toList();
      filteredData = data
          .where((element) =>
      similarStrings.contains(element.name.toLowerCase()) ||
          similarStrings.contains(element.gender.toLowerCase()) ||
          similarStrings.contains(element.location.toLowerCase()) ||
          similarStrings.contains(element.nationality.toLowerCase()))
          .toList();
    }

    return Scaffold(
      appBar: const HomeAppBar(),
      body: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(homelessControllerProvider);
            ref.read(homelessControllerProvider.notifier).getHomelessList();
          },
          child: Stack(
            children: [
              ListView.builder(
                controller: _scrollController,
                itemCount: filteredData.length + (homelessState.hasMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == filteredData.length) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  if (filteredData.isEmpty && !homelessState.hasMore) {
                    return const Center(
                      child: Text('No more homeless found.'),
                    );
                  }
                  final homeless = filteredData[index];
                  return HomelessListItem(
                    key: ValueKey(homeless.id),
                    homeless: homeless,
                    showPreferredIcon: true,
                    onChipClick: () {},
                    onClick: () {},
                  );
                },
              ),
              if (homelessState.error != null)
                Positioned(
                  bottom: 16,
                  left: 16,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    color: Colors.red,
                    child: Text(
                      'Error: ${homelessState.error.toString()}',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                )
            ],
          )),
    );
  }
}