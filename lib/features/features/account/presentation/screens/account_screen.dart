import 'package:flutter/material.dart';
import '../../../../../presentation/widgets/base_page_screen.dart';

/// Account Screen
class AccountScreen extends StatefulWidget {
  final Function(String) onNavigate;
  final VoidCallback onLogout;

  const AccountScreen({
    super.key,
    required this.onNavigate,
    required this.onLogout,
  });

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BasePageScreen(
      currentRoute: '/profile',
      onNavigate: widget.onNavigate,
      onLogout: widget.onLogout,
      pageTitle: 'Account',
      pageSubtitle: 'Manage your account settings',
      pageIcon: Icons.account_circle,
      iconBackgroundColor: const Color(0xFFE0E7FF), // bg-indigo-100
      searchController: _searchController,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Center(
          child: Text(
            'Account Settings',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
