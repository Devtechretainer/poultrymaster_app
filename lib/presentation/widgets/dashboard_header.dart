import 'package:flutter/material.dart';

/// Presentation Widget - Dashboard Header
/// Modern design with greeting, date, search bar, and profile
class DashboardHeader extends StatelessWidget {
  final TextEditingController? searchController;
  final String? username;
  final String? roleLabel;
  final bool showMenuButton;
  final VoidCallback? onMenuPressed;

  const DashboardHeader({
    super.key,
    this.searchController,
    this.username,
    this.roleLabel,
    this.showMenuButton = false,
    this.onMenuPressed,
  });

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 17) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }

  String _getFormattedDate() {
    final now = DateTime.now();
    final weekdays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    final months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return '${weekdays[now.weekday - 1]}, ${now.day} ${months[now.month - 1]} ${now.year}';
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmall = screenWidth < 600;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isSmall ? 16 : 24,
        vertical: 20,
      ),
      color: const Color(0xFF0F172A),
      child: Column(
        children: [
          Row(
            children: [
              // Hamburger Menu Button (visible on mobile to open drawer)
              if (showMenuButton)
                Builder(
                  builder: (builderContext) => IconButton(
                    icon: const Icon(Icons.menu, color: Colors.white, size: 24),
                    onPressed:
                        onMenuPressed ??
                        () {
                          Scaffold.of(builderContext).openDrawer();
                        },
                    tooltip: 'Open menu',
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ),
              if (showMenuButton) const SizedBox(width: 12),
              // Greeting and Date Section
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hello, ${_getGreeting()}!',
                      style: TextStyle(
                        fontSize: isSmall ? 22 : 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _getFormattedDate(),
                      style: TextStyle(
                        fontSize: isSmall ? 14 : 16,
                        color: Colors.grey[300],
                      ),
                    ),
                  ],
                ),
              ),
              // Profile Picture
              Container(
                width: isSmall ? 40 : 48,
                height: isSmall ? 40 : 48,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey[400]!, width: 2),
                ),
                child: ClipOval(
                  child: username != null && username!.isNotEmpty
                      ? Container(
                          color: Colors.green[400],
                          child: Center(
                            child: Text(
                              username!.substring(0, 1).toUpperCase(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: isSmall ? 18 : 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        )
                      : Icon(
                          Icons.person,
                          color: Colors.grey[600],
                          size: isSmall ? 24 : 28,
                        ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Search Bar
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.green[200]!, width: 1),
                  ),
                  child: TextField(
                    controller: searchController,
                    style: TextStyle(color: Colors.grey[800], fontSize: 16),
                    decoration: InputDecoration(
                      hintText: 'Search here...',
                      hintStyle: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 16,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Search Button
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  shape: BoxShape.circle,
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      // Handle search
                      if (searchController != null &&
                          searchController!.text.isNotEmpty) {
                        // TODO: Implement search functionality
                      }
                    },
                    borderRadius: BorderRadius.circular(25),
                    child: const Icon(
                      Icons.search,
                      color: Colors.green,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
