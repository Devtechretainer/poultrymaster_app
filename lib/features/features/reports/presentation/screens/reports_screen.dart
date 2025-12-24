import 'package:flutter/material.dart';
import '../../../../../presentation/widgets/base_page_screen.dart';

/// Reports Screen
class ReportsScreen extends StatefulWidget {
  final Function(String) onNavigate;
  final VoidCallback onLogout;

  const ReportsScreen({
    super.key,
    required this.onNavigate,
    required this.onLogout,
  });

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BasePageScreen(
      currentRoute: '/reports',
      onNavigate: widget.onNavigate,
      onLogout: widget.onLogout,
      pageTitle: 'Reports',
      pageSubtitle: 'View and generate farm reports',
      pageIcon: Icons.bar_chart,
      iconBackgroundColor: const Color(0xFFDBEAFE), // bg-blue-100
      searchController: _searchController,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Center(
          child: Text(
            'Reports Dashboard',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
