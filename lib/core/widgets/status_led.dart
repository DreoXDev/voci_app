import 'dart:math';

import 'package:flutter/material.dart';
import 'package:voci_app/features/homeless/data/models/homeless.dart';

class StatusLED extends StatefulWidget {
  final HomelessStatus status; // <-- Changed!
  final bool isPulsating;
  final double size;

  const StatusLED({
    super.key,
    required this.status, // <-- Changed!
    this.isPulsating = true,
    this.size = 16.0,
  });

  @override
  StatusLEDState createState() => StatusLEDState();
}

class StatusLEDState extends State<StatusLED>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late int animationTime;

  @override
  void initState() {
    super.initState();
    animationTime = Random().nextInt(500) +
        1000; // Random duration between 1 and 1.5 seconds
    _controller = AnimationController(
      duration: Duration(milliseconds: animationTime),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.5, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color getColor() {
    switch (widget.status) { // <-- Changed!
      case HomelessStatus.green: // <-- Changed!
        return Colors.green;
      case HomelessStatus.yellow: // <-- Changed!
        return Colors.yellow;
      case HomelessStatus.red: // <-- Changed!
        return Colors.red;
      case HomelessStatus.gray: return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: widget.isPulsating
                ? RadialGradient(
              colors: [
                getColor().withValues(alpha: _animation.value),
                Theme.of(context).colorScheme.surface,
              ],
            )
                : RadialGradient(
              colors: [
                getColor(),
                Colors.transparent,
              ],
            ),
          ),
        );
      },
    );
  }
}