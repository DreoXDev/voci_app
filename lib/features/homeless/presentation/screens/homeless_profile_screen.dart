import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voci_app/features/homeless/data/models/homeless.dart';

import '../providers.dart';

class HomelessProfileScreen extends ConsumerStatefulWidget {
  final String homelessId;

  const HomelessProfileScreen({
    super.key,
    required this.homelessId,
  });

  @override
  ConsumerState<HomelessProfileScreen> createState() => _HomelessProfileScreenState();
}

class _HomelessProfileScreenState extends ConsumerState<HomelessProfileScreen> {
  bool _isDescriptionExpanded = false;

  @override
  Widget build(BuildContext context) {
    final homelessAsyncValue = ref.watch(getHomelessByIdControllerProvider(widget.homelessId));
    return Scaffold(
      appBar: AppBar(
        title: homelessAsyncValue.when(
          data: (homelessState) => homelessState.value.when(
            data: (homeless) => Text(homeless.name),
            loading: () => const Text('Loading...'),
            error: (err, stack) => const Text('Error'),
          ),
          loading: () => const Text('Loading...'),
          error: (err, stack) => const Text('Error'),
        ),
      ),
      body: homelessAsyncValue.when(
        data: (homelessState) => homelessState.value.when(
          data: (homeless) => SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Status Chip
                _buildStatusChip(homeless.status),
                const SizedBox(height: 8),

                // Profile Header
                Text(
                  homeless.name,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),

                // Personal Information
                const Text('Personal Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                _buildInfoRow(Icons.person, 'Age: ${homeless.age}'),
                _buildInfoRow(Icons.wc, 'Gender: ${homeless.gender}'),
                _buildInfoRow(Icons.flag, 'Nationality: ${homeless.nationality}'),
                _buildInfoRow(Icons.pets, 'Pets: ${homeless.pets}'), // <-- Changed!

                const Divider(height: 24),

                // Background
                const Text('Background', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                _buildExpandableInfoRow(
                  Icons.description,
                  homeless.description,
                  _isDescriptionExpanded,
                      () {
                    setState(() {
                      _isDescriptionExpanded = !_isDescriptionExpanded;
                    });
                  },
                ),

                const Divider(height: 24),

                // Location/Contact
                const Text('Location/Contact', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                _buildInfoRow(Icons.map, 'Area: ${homeless.area}'),
                _buildInfoRow(Icons.location_on, 'Location: ${homeless.location}'), // <-- Changed!

                const Divider(height: 24),
              ],
            ),
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(child: Text('Error: $err')),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  // Helper function to build styled rows
  Widget _buildInfoRow(IconData icon, String text, {int? maxLines}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20), // Icon
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 16),
              maxLines: maxLines,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpandableInfoRow(IconData icon, String text, bool isExpanded, VoidCallback onToggle) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: GestureDetector( // <-- Added!
        onTap: onToggle, // <-- Added!
        child: Column( // <-- Changed!
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    text,
                    style: const TextStyle(fontSize: 16),
                    maxLines: isExpanded ? null : 3, // Show all lines if expanded, otherwise limit to 3
                    overflow: TextOverflow.fade,
                  ),
                ),
                IconButton(
                  icon: Icon(isExpanded ? Icons.expand_less : Icons.expand_more),
                  onPressed: onToggle,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) { // <-- Changed!
    Color chipColor;
    switch (_statusFromString(status)) { // <-- Changed!
      case HomelessStatus.green: // <-- Changed!
        chipColor = Colors.green;
        break;
      case HomelessStatus.yellow: // <-- Changed!
        chipColor = Colors.yellow;
        break;
      case HomelessStatus.red: // <-- Changed!
        chipColor = Colors.red;
        break;
      default:
        chipColor = Colors.grey;
        break;
    }
    return Chip(
      label: Text(status),
      backgroundColor: chipColor,
      labelStyle: const TextStyle(color: Colors.white),
    );
  }
  HomelessStatus _statusFromString(String statusString) {
    switch (statusString) {
      case 'RED':
        return HomelessStatus.red;
      case 'YELLOW':
        return HomelessStatus.yellow;
      case 'GREEN':
        return HomelessStatus.green;
      default:
        return HomelessStatus.gray;
    }
  }
}