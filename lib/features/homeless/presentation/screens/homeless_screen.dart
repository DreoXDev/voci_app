import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voci_app/features/homeless/domain/entities/homeless_entity.dart';
import 'package:voci_app/features/homeless/presentation/providers.dart';
import 'package:voci_app/features/homeless/presentation/screens/homeless_profile_screen.dart'; // <-- Added!
import 'package:voci_app/features/homeless/presentation/widgets/home_app_bar.dart';
import 'package:voci_app/features/homeless/presentation/widgets/homeless_list_item.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final _scrollController = ScrollController();
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(
        () => ref.read(homelessControllerProvider.notifier).getHomelessList());
    _scrollController.addListener(_onScroll);
    _searchController.addListener(_onSearch);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    _searchController
      ..removeListener(_onSearch)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      final homelessController = ref.read(homelessControllerProvider.notifier);
      if (homelessController.getIsSearching()) {
        homelessController.searchHomelessList(
            searchQuery: _searchController.text);
      } else {
        homelessController.getHomelessList();
      }
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  void _onSearch() {
    ref
        .read(homelessControllerProvider.notifier)
        .searchHomelessList(searchQuery: _searchController.text);
    if (_searchController.text.isEmpty) {
      ref.read(searchQueryProvider.notifier).state = "";
    } else {
      ref.read(searchQueryProvider.notifier).state = _searchController.text;
    }
  }

  //This is an example function, you need to update the database and all that stuff
  void _doSomethingWithHomeless(HomelessEntity homeless) {
    //Here update the database
    //Here do something with the data
  }

  // Placeholder function for the FAB action
  void _addHomeless() {
    // Implement the logic to add a new homeless person here.
  }

  @override
  Widget build(BuildContext context) {
    final homelessState = ref.watch(homelessControllerProvider);
    ref.watch(searchQueryProvider);
    final List<HomelessEntity> data = homelessState.data;

    return Scaffold(
      appBar: HomeAppBar(searchController: _searchController),
      floatingActionButton: FloatingActionButton(
        onPressed: _addHomeless,
        tooltip: 'Add Homeless',
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(homelessControllerProvider);
            ref.read(homelessControllerProvider.notifier).getHomelessList();
          },
          child: Stack(
            children: [
              ListView.builder(
                controller: _scrollController,
                itemCount: data.length + (homelessState.hasMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == data.length) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  if (data.isEmpty && !homelessState.hasMore) {
                    return const Center(
                      child: Text('No more homeless found.'),
                    );
                  }
                  final homeless = data[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Dismissible(
                      key: ValueKey(homeless.id),
                      direction: DismissDirection.startToEnd,
                      confirmDismiss: (direction) async {
                        return false;
                      },
                      onDismissed: (direction) {
                        _doSomethingWithHomeless(homeless);
                      },
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(left: 16),
                        child: const Icon(Icons.message, color: Colors.white),
                      ),
                      child: HomelessListItem(
                        key: ValueKey(homeless.id),
                        homeless: homeless,
                        showPreferredIcon: true,
                        onChipClick: () {},
                        onClick: () {
                          // <-- Corrected!
                          Navigator.of(context).push(
                            // <-- Corrected!
                            MaterialPageRoute(
                              // <-- Corrected!
                              builder: (context) => HomelessProfileScreen(
                                  homelessId: homeless.id), // <-- Corrected!
                            ), // <-- Corrected!
                          ); // <-- Corrected!
                        }, // <-- Corrected!
                      ),
                    ),
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
