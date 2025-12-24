import 'package:flutter/material.dart';
import '../widgets/base_page_screen.dart';

/// Resources Screen
class ResourcesScreen extends StatelessWidget {
  final Function(String) onNavigate;
  final VoidCallback onLogout;

  const ResourcesScreen({
    super.key,
    required this.onNavigate,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    final searchController = TextEditingController();

    return BasePageScreen(
      currentRoute: '/resources',
      onNavigate: onNavigate,
      onLogout: onLogout,
      pageTitle: 'Resources',
      pageSubtitle: 'Access farm resources and guides',
      pageIcon: Icons.book,
      iconBackgroundColor: const Color(0xFFF5F3FF),
      searchController: searchController,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.book, size: 64, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text(
                'Resources',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Farm resources and guides will be available here',
                style: TextStyle(fontSize: 16, color: Colors.grey[500]),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
