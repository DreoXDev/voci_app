import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voci_app/features/requests/domain/entities/request_entity.dart';
import 'package:voci_app/features/requests/presentation/widgets/request_detail_drawer.dart';
import 'package:voci_app/features/requests/presentation/widgets/request_list_item.dart';

import '../providers.dart';

class RequestsHistoryScreen extends ConsumerStatefulWidget {
  const RequestsHistoryScreen({super.key});

  @override
  ConsumerState<RequestsHistoryScreen> createState() =>
      _RequestsHistoryScreenState();
}

class _RequestsHistoryScreenState extends ConsumerState<RequestsHistoryScreen> {
  final _scrollController = ScrollController();
  bool _isLoadingMore = false;
  bool _isFirstLoadDone = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref
        .read(requestsHistoryControllerProvider.notifier)
        .getCompletedRequestsList());
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
    final requestsState = ref.read(requestsHistoryControllerProvider);
    if (_isBottom && requestsState.hasMore && !_isLoadingMore) {
      _isLoadingMore = true;
      ref
          .read(requestsHistoryControllerProvider.notifier)
          .getCompletedRequestsList()
          .then((_) => _isLoadingMore = false);
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  void _doSomethingWithRequest(RequestEntity request) {
    print("Do something with ${request.title}");
  }

  void _showRequestDetailDrawer(RequestEntity request) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      builder: (BuildContext context) {
        return RequestDetailDrawer(
          request: request,
          onAction1: () {
            _doSomethingWithRequest(request);
            Navigator.pop(context);
          },
          onAction2: () {
            print("Action 2 pressed for request: ${request.title}");
            Navigator.pop(context);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final requestsState = ref.watch(requestsHistoryControllerProvider);
    final List<RequestEntity> data = requestsState.data;

    if (!_isFirstLoadDone && data.isEmpty) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    _isFirstLoadDone = true;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Requests History"),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await ref
              .read(requestsHistoryControllerProvider.notifier)
              .refreshCompletedRequestsList();
        },
        child: ListView.builder(
          controller: _scrollController,
          itemCount: data.length + (requestsState.hasMore ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == data.length) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(),
                ),
              );
            }
            if (data.isEmpty && !requestsState.hasMore) {
              return const Center(
                child: Text('No more requests found.'),
              );
            }
            final request = data[index];
            return Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Dismissible(
                    key: ValueKey(request.id),
                    direction: DismissDirection.startToEnd,
                    confirmDismiss: (direction) async {
                      return false;
                    },
                    onDismissed: (direction) {
                      _doSomethingWithRequest(request);
                    },
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(left: 16),
                      child: const Icon(Icons.message, color: Colors.white),
                    ),
                    child: RequestListItem(
                      key: ValueKey(request.id),
                      request: request,
                      showPreferredIcon: true,
                      onChipClick: () {},
                      onClick: () => _showRequestDetailDrawer(request), // <-- Now opens the drawer
                    ),
                  ),
                ),
                if (requestsState.error != null)
                  Positioned(
                    bottom: 16,
                    left: 16,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      color: Colors.red,
                      child: Text(
                        'Error: ${requestsState.error.toString()}',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}