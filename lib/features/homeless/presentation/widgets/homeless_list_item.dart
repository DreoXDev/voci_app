import 'package:flutter/material.dart';
import 'package:voci_app/features/homeless/domain/entities/homeless_entity.dart';
import 'package:voci_app/core/widgets/custom_chip.dart';
import 'package:voci_app/core/widgets/status_led.dart';

class HomelessListItem extends StatefulWidget {
  final HomelessEntity homeless;
  final bool showPreferredIcon;
  final VoidCallback onChipClick;
  final VoidCallback onClick;

  const HomelessListItem({
    super.key,
    required this.homeless,
    required this.showPreferredIcon,
    required this.onChipClick,
    required this.onClick,
  });

  @override
  _HomelessListItemState createState() => _HomelessListItemState();
}

class _HomelessListItemState extends State<HomelessListItem> {
  bool isPreferred = false;

  void togglePreferred() {
    setState(() {
      isPreferred = !isPreferred;
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onClick,
      child: Container(
        height: 75.0,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Left Section: Name & Status LED
            Flexible(
              child: Row(
                children: [
                  StatusLED(status: widget.homeless.status, size: 24.0,),
                  const SizedBox(width: 8.0),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.homeless.name,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          "${widget.homeless.gender}, ${widget.homeless.age}, ${widget.homeless.nationality}",
                          style: Theme.of(context)
                              .textTheme
                              .labelSmall
                              ?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withValues(),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Right Section: Location Chip & Preferred Icon
            Flexible(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: CustomChip(
                      text: widget.homeless.location,
                      icon: Icons.location_on,
                      onTap: widget.onChipClick,
                    ),
                  ),
                  if (widget.showPreferredIcon)
                    IconButton(
                      onPressed: togglePreferred,
                      icon: Icon(
                        isPreferred ? Icons.star : Icons.star_border,
                        color: isPreferred
                            ? Theme.of(context).colorScheme.secondary
                            : Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}