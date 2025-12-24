import 'package:flutter/material.dart';
import '../../../../../presentation/widgets/base_page_screen.dart';

/// Overview/Dashboard Screen
class OverviewScreen extends StatefulWidget {
  final Function(String) onNavigate;
  final VoidCallback onLogout;

  const OverviewScreen({
    super.key,
    required this.onNavigate,
    required this.onLogout,
  });

  @override
  State<OverviewScreen> createState() => _OverviewScreenState();
}

class _OverviewScreenState extends State<OverviewScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BasePageScreen(
      currentRoute: '/dashboard',
      onNavigate: widget.onNavigate,
      onLogout: widget.onLogout,
      pageTitle: 'Overview',
      pageSubtitle: 'Dashboard summary and quick insights',
      pageIcon: Icons.home,
      iconBackgroundColor: const Color(0xFFDBEAFE), // bg-blue-100
      searchController: _searchController,
      child: const Center(
        child: Text(
          'Dashboard Overview',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
