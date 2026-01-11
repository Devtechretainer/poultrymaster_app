import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../domain/entities/customer.dart';
import '../../../../../presentation/widgets/base_page_screen.dart';
import '../../../../../presentation/widgets/empty_state_widget.dart';
import '../../../../../presentation/widgets/info_item_widget.dart';
import '../../../../../presentation/widgets/loading_widget.dart';
import '../../../../../application/providers/customer_providers.dart';
import '../../../../../presentation/screens/add_customer_screen.dart';

/// Customers Screen - Main customer management interface
/// Matches the frontend FarmArchive design exactly
class CustomersScreen extends ConsumerStatefulWidget {
  final Function(String) onNavigate;
  final VoidCallback onLogout;

  const CustomersScreen({
    super.key,
    required this.onNavigate,
    required this.onLogout,
  });

  @override
  ConsumerState<CustomersScreen> createState() => _CustomersScreenState();
}

class _CustomersScreenState extends ConsumerState<CustomersScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Load customers when screen is opened
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(customerControllerProvider.notifier).loadCustomers();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _navigateToAddCustomer() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const AddCustomerScreen()));
  }

  void _showCustomerDetail(Customer customer) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Customer Details',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  InfoItemWidget(
                    icon: Icons.person_outline,
                    label: 'Name',
                    value: customer.name,
                  ),
                  if (customer.contactEmail != null && customer.contactEmail!.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    InfoItemWidget(
                      icon: Icons.email_outlined,
                      label: 'Email',
                      value: customer.contactEmail!,
                    ),
                  ],
                  if (customer.contactPhone != null && customer.contactPhone!.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    InfoItemWidget(
                      icon: Icons.phone_outlined,
                      label: 'Phone',
                      value: customer.contactPhone!,
                    ),
                  ],
                  if (customer.city != null && customer.city!.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    InfoItemWidget(
                      icon: Icons.location_city_outlined,
                      label: 'City',
                      value: customer.city!,
                    ),
                  ],
                  if (customer.address != null && customer.address!.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    InfoItemWidget(
                      icon: Icons.location_on_outlined,
                      label: 'Address',
                      value: customer.address!,
                    ),
                  ],
                  if (customer.createdDate != null) ...[
                    const SizedBox(height: 16),
                    InfoItemWidget(
                      icon: Icons.calendar_today_outlined,
                      label: 'Created Date',
                      value: customer.createdDate!.toLocal().toString().split(' ')[0],
                    ),
                  ],
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _navigateToEditCustomer(customer);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2563EB),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Edit Customer'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _navigateToEditCustomer(Customer customer) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => AddCustomerScreen(customer: customer)),
    );
  }

  Future<void> _deleteCustomer(int customerId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Deletion'),
        content: const Text('Are you sure you want to delete this customer?'),
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
      await ref.read(customerControllerProvider.notifier).deleteCustomer(customerId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final customerState = ref.watch(customerControllerProvider);
    final customers = customerState.customers;
    final isLoading = customerState.isLoading;
    final error = customerState.error;

    return BasePageScreen(
      currentRoute: '/customers',
      onNavigate: widget.onNavigate,
      onLogout: widget.onLogout,
      pageTitle: 'Customers',
      pageSubtitle: 'Manage your customer database',
      pageIcon: Icons.people,
      iconBackgroundColor: const Color(0xFFF3E8FF), // bg-purple-100
      searchController: _searchController,
      actionButton: ElevatedButton.icon(
        onPressed: _navigateToAddCustomer,
        icon: const Icon(Icons.add, color: Colors.white, size: 16),
        label: const Text(
          'Add Customer',
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2563EB), // bg-blue-600
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      child: _buildContent(customers, isLoading, error),
    );
  }

  Widget _buildContent(List<Customer> customers, bool isLoading, String? error) {
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
                  ref.read(customerControllerProvider.notifier).loadCustomers();
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (customers.isEmpty) {
      return EmptyStateWidget(
        icon: Icons.people_outline,
        title: 'No customers found',
        subtitle: 'Get started by adding your first customer',
        buttonLabel: 'Add Your First Customer',
        onButtonPressed: _navigateToAddCustomer,
      );
    }

    // Customers list - Card-based layout
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: customers.length,
      itemBuilder: (context, index) {
        final customer = customers[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _CustomerCard(
            customer: customer,
            index: index + 1,
            onViewDetail: () => _showCustomerDetail(customer),
            onEdit: () => _navigateToEditCustomer(customer),
            onDelete: () => _deleteCustomer(customer.customerId!),
          ),
        );
      },
    );
  }
}

/// Customer Card Widget - Card-based design inspired by modern UI
class _CustomerCard extends StatelessWidget {
  final Customer customer;
  final int index;
  final VoidCallback onViewDetail;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _CustomerCard({
    required this.customer,
    required this.index,
    required this.onViewDetail,
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
                    customer.name,
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
            if (customer.contactEmail != null) ...[
              _InfoItem(
                icon: Icons.email_outlined,
                label: 'Email',
                value: customer.contactEmail!,
              ),
              const SizedBox(height: 12),
            ],
            if (customer.contactPhone != null) ...[
              _InfoItem(
                icon: Icons.phone_outlined,
                label: 'Phone',
                value: customer.contactPhone!,
              ),
              const SizedBox(height: 12),
            ],
            if (customer.city != null) ...[
              _InfoItem(
                icon: Icons.location_city_outlined,
                label: 'City',
                value: customer.city!,
              ),
              const SizedBox(height: 12),
            ],
            if (customer.address != null) ...[
              _InfoItem(
                icon: Icons.location_on_outlined,
                label: 'Address',
                value: customer.address!,
              ),
              const SizedBox(height: 16),
            ],
            // Action button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onViewDetail,
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

/// Info Item Widget - Displays icon, label, and value
class _InfoItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: const Color(0xFF0F172A)),
        const SizedBox(width: 10),
        Text(
          '$label: ',
          style: const TextStyle(
            fontSize: 15,
            color: Color(0xFF0F172A),
            fontWeight: FontWeight.w500,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Color(0xFF0F172A),
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
