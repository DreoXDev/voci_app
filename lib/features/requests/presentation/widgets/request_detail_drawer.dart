import 'package:flutter/material.dart';
import 'package:voci_app/core/widgets/custom_chip.dart';
import 'package:voci_app/features/homeless/presentation/providers.dart';
import 'package:voci_app/features/requests/domain/entities/request_entity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../homeless/data/providers.dart';

class RequestDetailDrawer extends ConsumerWidget {
  final RequestEntity request;
  final VoidCallback onAction1;
  final VoidCallback onAction2;

  const RequestDetailDrawer({
    super.key,
    required this.request,
    required this.onAction1,
    required this.onAction2,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homelessNames = ref.watch(homelessNamesProvider);
    final homelessName = homelessNames[request.homelessID] ?? "Unknown";
    return SizedBox(
      height: MediaQuery.of(context).size.height / 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Date
                Text(
                  DateFormat('dd/MM/yyyy').format(DateTime.fromMillisecondsSinceEpoch(request.timestamp)),
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                // Close Button
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            // Title
            Text(
              request.title,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            // Description
            Text(
              request.description,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            //Chip with name
            CustomChip(
              text: homelessName,
              onTap: () {},
              icon: Icons.assignment_ind,
            ),
            const Spacer(),
            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: onAction1,
                    child: const Text('Action 1'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onAction2,
                    child: const Text('Action 2'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}