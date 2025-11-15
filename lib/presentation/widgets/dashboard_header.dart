import 'package:flutter/material.dart';
import '../../domain/entities/user.dart';

/// Presentation Widget - Dashboard Header
class DashboardHeader extends StatelessWidget {
  final User? user;
  final Function(String) onSearch;
  final bool showDrawerButton;
  final VoidCallback? onDrawerPressed;

  const DashboardHeader({
    super.key,
    this.user,
    required this.onSearch,
    this.showDrawerButton = false,
    this.onDrawerPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      color: Colors.grey[100],
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Row(
        children: [
          // Drawer button (mobile only)
          if (showDrawerButton && onDrawerPressed != null)
            IconButton(
              icon: const Icon(Icons.menu),
              onPressed: onDrawerPressed,
            ),
          // Search Bar
          Expanded(
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: TextField(
                decoration: const InputDecoration(
                  hintText: 'Search...',
                  prefixIcon: Icon(Icons.search, color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                ),
                onSubmitted: onSearch,
              ),
            ),
          ),
          const SizedBox(width: 16),
          // User Info
          if (user != null) ...[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Admin',
                  style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                ),
                Text(
                  user!.username,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 8),
            CircleAvatar(
              backgroundColor: Colors.blue,
              child: Text(
                user!.firstName[0].toUpperCase(),
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
          const SizedBox(width: 16),
          // Notifications
          IconButton(
            icon: Stack(
              children: [
                const Icon(Icons.notifications_outlined, size: 28),
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
            onPressed: () {
              // Handle notifications
            },
          ),
          const SizedBox(width: 8),
          // User Menu
          IconButton(
            icon: const Icon(Icons.account_circle, size: 28),
            onPressed: () {
              // Handle user menu
            },
          ),
        ],
      ),
    );
  }
}
