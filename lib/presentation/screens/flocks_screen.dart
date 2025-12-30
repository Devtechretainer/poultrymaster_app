import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/providers/flock_providers.dart';
import '../../domain/entities/flock.dart';
import '../widgets/base_page_screen.dart';
import '../widgets/empty_state_widget.dart';
import '../widgets/loading_widget.dart';
import 'flock_add_edit_form_screen.dart';

/// Flocks Screen
class FlocksScreen extends ConsumerStatefulWidget {
  final Function(String) onNavigate;
  final VoidCallback onLogout;

  const FlocksScreen({
    super.key,
    required this.onNavigate,
    required this.onLogout,
  });

  @override
  ConsumerState<FlocksScreen> createState() => _FlocksScreenState();
}

class _FlocksScreenState extends ConsumerState<FlocksScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(flockControllerProvider.notifier).loadFlocks();
    });
  }

  void _navigateToAddFlock() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const FlockAddEditFormScreen()));
  }

  void _navigateToEditFlock(Flock flock) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => FlockAddEditFormScreen(flock: flock)),
    );
  }

  Future<void> _deleteFlock(int flockId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Deletion'),
        content: const Text('Are you sure you want to delete this flock?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref.read(flockControllerProvider.notifier).deleteFlock(flockId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final flockState = ref.watch(flockControllerProvider);
    final flocks = flockState.flocks;
    final isLoading = flockState.isLoading;
    final error = flockState.error;

    return BasePageScreen(
      currentRoute: '/flocks',
      onNavigate: widget.onNavigate,
      onLogout: widget.onLogout,
      pageTitle: 'Flocks',
      pageSubtitle: 'Manage your bird flocks',
      pageIcon: Icons.eco,
      iconBackgroundColor: const Color(0xFFECFDF5),
      searchController: _searchController,
      actionButton: ElevatedButton.icon(
        onPressed: _navigateToAddFlock,
        icon: const Icon(Icons.add, color: Colors.white, size: 16),
        label: const Text(
          'Add Flock',
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2563EB),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      child: _buildContent(flocks, isLoading, error),
    );
  }

  Widget _buildContent(List<Flock> flocks, bool isLoading, String? error) {
    if (isLoading) {
      return const Padding(
        padding: EdgeInsets.all(32.0),
        child: LoadingWidget.large(),
      );
    }

    if (error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Error: $error',
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  ref.read(flockControllerProvider.notifier).loadFlocks();
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (flocks.isEmpty) {
      return EmptyStateWidget(
        icon: Icons.eco,
        title: 'No flocks found',
        subtitle: 'Get started by adding your first flock',
        buttonLabel: 'Add Your First Flock',
        onButtonPressed: _navigateToAddFlock,
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: flocks.length,
      itemBuilder: (context, index) {
        final flock = flocks[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _FlockCard(
            flock: flock,
            index: index + 1,
            onEdit: () => _navigateToEditFlock(flock),
            onDelete: () => _deleteFlock(flock.flockId),
          ),
        );
      },
    );
  }
}

/// Flock Card Widget - Card-based design
class _FlockCard extends StatelessWidget {
  final Flock flock;
  final int index;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _FlockCard({
    required this.flock,
    required this.index,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate age in days
    final ageInDays = DateTime.now().difference(flock.startDate).inDays;

    return Card(
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with number and title
            Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '$index',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    flock.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'edit') {
                      onEdit();
                    } else if (value == 'delete') {
                      onDelete();
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit, size: 18),
                          SizedBox(width: 8),
                          Text('Edit'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, size: 18, color: Colors.red),
                          SizedBox(width: 8),
                          Text('Delete', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Info items with icons
            _InfoItem(
              icon: Icons.category_outlined,
              label: 'Breed',
              value: flock.breed,
            ),
            const SizedBox(height: 12),
            _InfoItem(
              icon: Icons.numbers_outlined,
              label: 'Quantity',
              value: '${flock.quantity} birds',
            ),
            const SizedBox(height: 12),
            _InfoItem(
              icon: Icons.calendar_today_outlined,
              label: 'Age',
              value: '$ageInDays days',
            ),
            const SizedBox(height: 12),
            _InfoItem(
              icon: Icons.check_circle_outline,
              label: 'Status',
              value: flock.active ? 'Active' : 'Inactive',
            ),
            if (flock.batchName != null) ...[
              const SizedBox(height: 12),
              _InfoItem(
                icon: Icons.inventory_2_outlined,
                label: 'Batch',
                value: flock.batchName!,
              ),
            ],
            const SizedBox(height: 16),
            // Action button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onEdit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[100],
                  foregroundColor: Colors.grey[800],
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('View Details'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Info Item Widget - Displays icon, label, and value
class _InfoItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
