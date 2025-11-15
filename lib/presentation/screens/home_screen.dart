import 'package:flutter/material.dart';
import 'dashboard_screen.dart';

/// Presentation Screen - Home (redirects to Dashboard)
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const DashboardScreen();
  }
}
