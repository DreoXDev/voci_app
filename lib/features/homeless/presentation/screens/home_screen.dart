import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voci_app/features/homeless/domain/entities/homeless_entity.dart';
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
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(homelessControllerProvider.notifier).getHomelessList());
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
      if(homelessController.getIsSearching()){
        homelessController.searchHomelessList(searchQuery: _searchController.text);
      }else{
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
  void _onSearch(){
    ref.read(homelessControllerProvider.notifier).searchHomelessList(searchQuery: _searchController.text);
    if (_searchController.text.isEmpty) {
      ref.read(searchQueryProvider.notifier).state = "";
    } else {
      ref.read(searchQueryProvider.notifier).state = _searchController.text;
    }
  }

  @override
  Widget build(BuildContext context) {
    final homelessState = ref.watch(homelessControllerProvider);
    ref.watch(searchQueryProvider);
    final List<HomelessEntity> data = homelessState.data;

    return Scaffold(
      appBar:  HomeAppBar(searchController: _searchController),
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