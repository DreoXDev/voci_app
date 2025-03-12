import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:voci_app/features/requests/domain/entities/request_entity.dart';

import '../../../../core/widgets/custom_chip.dart';
import '../../../homeless/data/providers.dart'; // <-- Added!

class RequestListItem extends ConsumerWidget {
  final RequestEntity request;
  final VoidCallback onChipClick;
  final VoidCallback onClick;
  final bool showPreferredIcon;

  const RequestListItem({
    super.key,
    required this.request,
    required this.onChipClick,
    required this.onClick,
    this.showPreferredIcon = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homelessNames = ref.watch(homelessNamesProvider);
    final homelessName = homelessNames[request.homelessID] ?? "Unknown";
    return GestureDetector(
      onTap: onClick,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: Material(
          elevation: 16,
          borderRadius: BorderRadius.circular(16),
          color: Theme.of(context).colorScheme.surface,
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    top: 8.0, bottom: 8.0, right: 0.0, left: 12.0),
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _getIcon(request.iconCategory), // <-- Changed!
                    color: Theme.of(context).colorScheme.onPrimary,
                    size: 24,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              request.title,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color:
                                Theme.of(context).colorScheme.primary,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                          Text(
                            DateFormat('dd/MM/yyyy').format(
                                DateTime.fromMillisecondsSinceEpoch(
                                    request.timestamp)),
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium
                                ?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        request.description,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color:
                            Theme.of(context).colorScheme.onSurfaceVariant),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      const SizedBox(height: 8),
                      CustomChip(
                        text: homelessName,
                        onTap: onChipClick,
                        icon: Icons.assignment_ind,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getIcon(String iconCategory) {
    switch (iconCategory) {
      case "other":
        return Icons.category;
      case "shoes":
        return Icons.checkroom_outlined;
      case "pants":
        return Icons.checkroom_outlined;
      case "shirt":
        return Icons.checkroom_outlined;
      case "cap":
        return Icons.checkroom_outlined;
      case "underwear":
        return Icons.checkroom_outlined;
      default:
        return Icons.category;
    }
  }
}