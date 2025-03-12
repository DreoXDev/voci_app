import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voci_app/features/homeless/presentation/providers.dart';

class HomeAppBar extends ConsumerStatefulWidget
    implements PreferredSizeWidget {
  final TextEditingController searchController;
  const HomeAppBar({super.key, required this.searchController});

  @override
  ConsumerState<HomeAppBar> createState() => _HomeAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(80);
}

class _HomeAppBarState extends ConsumerState<HomeAppBar> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Listen to changes in the query
    final query = ref.watch(searchQueryProvider);

    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.surface,
      titleSpacing: 16.0,
      toolbarHeight: 80,
      centerTitle: true,
      elevation: 0,
      title: SearchBar(
        controller: widget.searchController,
        hintText: 'Search',
        leading: const Icon(Icons.search),
        elevation: WidgetStateProperty.all(0),
        backgroundColor: WidgetStateProperty.all(
            Theme.of(context).colorScheme.primaryContainer),
        onChanged: (value) {
          // Only update state if it's different
          if (query != value) {
            ref.read(searchQueryProvider.notifier).state = value;
          }
        },
      ),
    );
  }
}