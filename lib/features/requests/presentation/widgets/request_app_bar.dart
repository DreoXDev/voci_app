import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RequestsAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final VoidCallback onNavigate;

  const RequestsAppBar({
    super.key,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppBar(
      title: const Text("Requests"),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.list),
          onPressed: onNavigate,
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}