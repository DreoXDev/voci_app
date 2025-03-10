import 'package:flutter/material.dart';

class CustomChip extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onTap;

  const CustomChip({super.key, required this.text, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Chip(
        avatar: Icon(icon, size: 16),
        label: Text(
          text,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
      ),
    );
  }
}
