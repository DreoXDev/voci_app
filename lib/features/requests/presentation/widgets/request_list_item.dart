import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/game_icons.dart';
import 'package:iconify_flutter/icons/icon_park_twotone.dart';
import 'package:iconify_flutter/icons/iconoir.dart';
import 'package:iconify_flutter/icons/material_symbols.dart';
import 'package:iconify_flutter/icons/tabler.dart';
import 'package:intl/intl.dart';
import 'package:voci_app/features/requests/domain/entities/request_entity.dart';
import '../../../../core/widgets/custom_chip.dart';
import '../../../homeless/data/providers.dart';

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
                  child: Center(
                    child: _getIcon(request.iconCategory), // Return an Iconify widget
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

  Widget _getIcon(String iconCategory) {
    //We now return the widget directly.
    switch (iconCategory) {
      case "other":
        return const Iconify(MaterialSymbols.category, color: Colors.white,);
      case "shoes":
        return const Iconify(Tabler.shoe, color: Colors.white,);
      case "pants":
        return const Iconify(Iconoir.pants, color: Colors.white,);
      case "shirt":
        return const Iconify(Tabler.shirt, color: Colors.white,);
      case "cap":
        return const Iconify(IconParkTwotone.hat, color: Colors.white,);
      case "underwear":
        return const Iconify(GameIcons.underwear, color: Colors.white,);
      default:
        return const Iconify(MaterialSymbols.category, color: Colors.white,);
    }
  }
}