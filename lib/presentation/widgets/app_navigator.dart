import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../screens/dashboard_screen.dart';
import '../screens/flock_batch_screen.dart';
import '../screens/flocks_screen.dart';
import '../screens/production_records_screen.dart';
import '../screens/egg_production_screen.dart';
import '../screens/feed_usage_screen.dart';
import '../screens/health_screen.dart';
import '../screens/inventory_screen.dart';
import '../screens/supplies_screen.dart';
import '../screens/sales_screen.dart';
import '../screens/expenses_screen.dart';
import '../screens/resources_screen.dart';
import '../screens/employees_screen.dart';
import '../screens/reports_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/houses_screen.dart';
import '../../features/features/customer/presentation/screens/customers_screen.dart';

/// Navigation helper to get the appropriate screen for a route
class AppNavigator {
  /// Get screen widget for a given route
  static Widget? getScreenForRoute(
    String route,
    WidgetRef ref,
    Function(String) onNavigate,
    VoidCallback onLogout,
  ) {
    switch (route) {
      case '/dashboard':
      case '/overview':
        return const DashboardScreen();
      case '/customers':
        return CustomersScreen(onNavigate: onNavigate, onLogout: onLogout);
      case '/flock-batch':
        return FlockBatchScreen(onNavigate: onNavigate, onLogout: onLogout);
      case '/flocks':
        return FlocksScreen(onNavigate: onNavigate, onLogout: onLogout);
      case '/production-records':
        return ProductionRecordsScreen(
          onNavigate: onNavigate,
          onLogout: onLogout,
        );
      case '/egg-production':
        return EggProductionScreen(onNavigate: onNavigate, onLogout: onLogout);
      case '/feed-usage':
        return FeedUsageScreen(onNavigate: onNavigate, onLogout: onLogout);
      case '/health':
        return HealthScreen(onNavigate: onNavigate, onLogout: onLogout);
      case '/inventory':
        return InventoryScreen(onNavigate: onNavigate, onLogout: onLogout);
      case '/supplies':
        return SuppliesScreen(onNavigate: onNavigate, onLogout: onLogout);
      case '/sales':
        return SalesScreen(onNavigate: onNavigate, onLogout: onLogout);
      case '/expenses':
        return ExpensesScreen(onNavigate: onNavigate, onLogout: onLogout);
      case '/resources':
        return ResourcesScreen(onNavigate: onNavigate, onLogout: onLogout);
      case '/employees':
        return EmployeesScreen(onNavigate: onNavigate, onLogout: onLogout);
      case '/reports':
        return ReportsScreen(onNavigate: onNavigate, onLogout: onLogout);
      case '/profile':
      case '/account':
        return ProfileScreen(onNavigate: onNavigate, onLogout: onLogout);
      case '/houses':
        return HousesScreen(onNavigate: onNavigate, onLogout: onLogout);
      default:
        return null;
    }
  }
}
