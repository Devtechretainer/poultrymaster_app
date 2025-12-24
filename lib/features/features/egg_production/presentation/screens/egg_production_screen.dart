import 'package:flutter/material.dart';
import '../../../../../presentation/widgets/base_page_screen.dart';
import '../../../../../presentation/widgets/empty_state_widget.dart';

/// Egg Production Screen
class EggProductionScreen extends StatefulWidget {
  final Function(String) onNavigate;
  final VoidCallback onLogout;

  const EggProductionScreen({
    super.key,
    required this.onNavigate,
    required this.onLogout,
  });

  @override
  State<EggProductionScreen> createState() => _EggProductionScreenState();
}

class _EggProductionScreenState extends State<EggProductionScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<dynamic> _records = []; // Empty for now

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BasePageScreen(
      currentRoute: '/egg-production',
      onNavigate: widget.onNavigate,
      onLogout: widget.onLogout,
      pageTitle: 'Egg Production',
      pageSubtitle: 'Track and manage egg production',
      pageIcon: Icons.whatshot,
      iconBackgroundColor: const Color(0xFFFED7AA), // bg-orange-100
      searchController: _searchController,
      actionButton: ElevatedButton.icon(
        onPressed: () {},
        icon: const Icon(Icons.add, color: Colors.white, size: 16),
        label: const Text(
          'Add Record',
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2563EB), // bg-blue-600
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      child: _records.isEmpty
          ? EmptyStateWidget(
              icon: Icons.whatshot,
              title: 'No egg production records found',
              subtitle:
                  'Get started by adding your first egg production record',
              buttonLabel: 'Add Your First Record',
              onButtonPressed: () {},
            )
          : Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(child: Text('Egg Production Records List')),
            ),
    );
  }
}
