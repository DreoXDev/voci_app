import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:voci_app/features/requests/domain/entities/request_entity.dart';
import 'package:voci_app/features/requests/presentation/providers.dart';
import 'package:voci_app/features/requests/presentation/widgets/request_detail_drawer.dart';
import 'package:voci_app/features/requests/presentation/widgets/request_list_item.dart';
import '../widgets/add_modify_dialog.dart';
import '../widgets/request_app_bar.dart';
import 'package:voci_app/features/requests/data/models/request.dart';

class RequestsScreen extends ConsumerStatefulWidget {
  const RequestsScreen({super.key});

  @override
  ConsumerState<RequestsScreen> createState() => _RequestsScreenState();
}

class _RequestsScreenState extends ConsumerState<RequestsScreen> {
  final _scrollController = ScrollController();
  bool _isLoadingMore = false;
  bool _isFirstLoadDone = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        ref.read(requestsControllerProvider.notifier).getActiveRequestsList());
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
    final requestsState = ref.read(requestsControllerProvider);
    if (_isBottom && requestsState.hasMore && !_isLoadingMore) {
      _isLoadingMore = true;
      ref
          .read(requestsControllerProvider.notifier)
          .getActiveRequestsList()
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
    //TODO: add a correct function
  }

  void _modifyRequest(RequestEntity request) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return AddModifyRequestDialog(
          title: 'Modify Request',
          initialRequest: request.toModel(),
          onSave: (Request modifiedRequest) async {
            try {
              final updates = modifiedRequest.toMap();
              await ref
                  .read(requestsControllerProvider.notifier)
                  .modifyRequest(request.id, updates);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Request modified successfully')),
                );
              }
            } catch (e) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error modifying request: $e')),
                );
              }
            }
          },
        );
      },
    );
  }

  void _completeRequest(RequestEntity request) async {
    try {
      await ref
          .read(requestsControllerProvider.notifier)
          .completeRequest(request.id);
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Request completed successfully')),
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error completing request: $e')),
      );
    }
  }

  void _addRequest() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return AddModifyRequestDialog(
          title: 'Add Request',
          onSave: (Request newRequest) async {
            try {
              await ref.read(requestsControllerProvider.notifier).addRequest(newRequest.toEntity());
              // Optionally show a success message
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Request added successfully')),
                );
              }
            } catch (e) {
              // Handle errors
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error adding request: $e')),
                );
              }
            }
          },
        );
      },
    );
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
            _modifyRequest(request);
            Navigator.pop(context);
          },
          onAction2: () {
            _completeRequest(request);
            Navigator.pop(context);
          },
        );
      },
    );
  }

  void _navigateToHistory() {
    context.push('/requests/history');
  }

  @override
  Widget build(BuildContext context) {
    final requestsState = ref.watch(requestsControllerProvider);
    final List<RequestEntity> data = requestsState.data;

    if (!_isFirstLoadDone && data.isEmpty) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    _isFirstLoadDone = true;

    return Scaffold(
      appBar: RequestsAppBar(
        onNavigate: _navigateToHistory,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addRequest,
        tooltip: 'Add request',
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(requestsControllerProvider);
          await ref
              .read(requestsControllerProvider.notifier)
              .getActiveRequestsList();
        },
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (data.isEmpty && !requestsState.hasMore) {
              return SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: SizedBox(
                  height: constraints.maxHeight,
                  child: const Center(
                    child: Text(
                      'No more requests found. Pull down to refresh.',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              );
            }
            return ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
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
                          onClick: () => _showRequestDetailDrawer(request),
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
            );
          },
        ),
      ),
    );
  }
}