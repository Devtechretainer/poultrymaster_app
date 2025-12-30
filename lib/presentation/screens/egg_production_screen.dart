import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/providers/egg_production_providers.dart';
import '../../domain/entities/egg_production.dart';
import '../widgets/base_page_screen.dart';
import '../widgets/empty_state_widget.dart';
import '../widgets/info_item_widget.dart';
import '../widgets/loading_widget.dart';
import 'add_edit_egg_production_screen.dart';

class EggProductionScreen extends ConsumerStatefulWidget {
  final Function(String) onNavigate;
  final VoidCallback onLogout;

  const EggProductionScreen({
    super.key,
    required this.onNavigate,
    required this.onLogout,
  });

  @override
  ConsumerState<EggProductionScreen> createState() =>
      _EggProductionScreenState();
}

class _EggProductionScreenState extends ConsumerState<EggProductionScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(eggProductionControllerProvider.notifier).loadEggProductions();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _navigateToAddEggProduction() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const AddEditEggProductionScreen()),
    );
  }

  void _navigateToEditEggProduction(EggProduction eggProduction) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) =>
            AddEditEggProductionScreen(eggProduction: eggProduction),
      ),
    );
  }

  Future<void> _deleteEggProduction(int id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Deletion'),
        content: const Text(
          'Are you sure you want to delete this egg production record?',
        ),
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
      await ref
          .read(eggProductionControllerProvider.notifier)
          .deleteEggProduction(id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final eggProductionState = ref.watch(eggProductionControllerProvider);
    final eggProductions = eggProductionState.eggProductions;
    final isLoading = eggProductionState.isLoading;
    final error = eggProductionState.error;

    return BasePageScreen(
      currentRoute: '/egg-production',
      onNavigate: widget.onNavigate,
      onLogout: widget.onLogout,
      pageTitle: 'Egg Production',
      pageSubtitle: 'Track egg production records',
      pageIcon: Icons.whatshot,
      iconBackgroundColor: const Color(0xFFFFF1F2),
      searchController: _searchController,
      actionButton: ElevatedButton.icon(
        onPressed: _navigateToAddEggProduction,
        icon: const Icon(Icons.add, color: Colors.white, size: 16),
        label: const Text(
          'Record Eggs',
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2563EB),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      child: _buildContent(eggProductions, isLoading, error),
    );
  }

  Widget _buildContent(
    List<EggProduction> eggProductions,
    bool isLoading,
    String? error,
  ) {
    if (isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: LoadingWidget.large(),
        ),
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
                  ref
                      .read(eggProductionControllerProvider.notifier)
                      .loadEggProductions();
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (eggProductions.isEmpty) {
      return EmptyStateWidget(
        icon: Icons.whatshot,
        title: 'No egg production records found',
        subtitle: 'Start tracking by recording your first egg production',
        buttonLabel: 'Record Your First Eggs',
        onButtonPressed: _navigateToAddEggProduction,
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: eggProductions.length,
      itemBuilder: (context, index) {
        final record = eggProductions[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _EggProductionCard(
            record: record,
            index: index + 1,
            onEdit: () => _navigateToEditEggProduction(record),
            onDelete: () => _deleteEggProduction(record.productionId),
          ),
        );
      },
    );
  }
}

/// Egg Production Card Widget - Card-based design
class _EggProductionCard extends StatelessWidget {
  final EggProduction record;
  final int index;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _EggProductionCard({
    required this.record,
    required this.index,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
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
                    'Flock ${record.flockId}',
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
            InfoItemWidget(
              icon: Icons.calendar_today_outlined,
              label: 'Date',
              value: record.productionDate.toLocal().toString().split(' ')[0],
            ),
            const SizedBox(height: 12),
            InfoItemWidget(
              icon: Icons.egg_outlined,
              label: 'Total Production',
              value: '${record.totalProduction} eggs',
            ),
            const SizedBox(height: 12),
            InfoItemWidget(
              icon: Icons.broken_image_outlined,
              label: 'Broken Eggs',
              value: '${record.brokenEggs}',
            ),
            if (record.notes != null && record.notes!.isNotEmpty) ...[
              const SizedBox(height: 12),
              InfoItemWidget(
                icon: Icons.note_outlined,
                label: 'Notes',
                value: record.notes!,
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
