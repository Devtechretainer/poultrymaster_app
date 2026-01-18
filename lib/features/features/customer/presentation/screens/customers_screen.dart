import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../domain/entities/customer.dart';
import '../../../../../presentation/widgets/base_page_screen.dart';
import '../../../../../presentation/widgets/empty_state_widget.dart';
import '../../../../../presentation/widgets/loading_widget.dart';
import '../../../../../presentation/widgets/unified_list_card_widget.dart';
import '../../../../../application/providers/customer_providers.dart';
import '../../../../../presentation/screens/add_customer_screen.dart';
import '../../../../../presentation/widgets/ereceipt_detail_widget.dart';
import '../../../../../presentation/widgets/asset_image_widget.dart';

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
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EReceiptDetailWidget(
          title: 'Customer Details',
          sections: [
            // Item Card Section
            DetailSection(
              type: DetailSectionType.itemCard,
              title: customer.name,
              subtitle: customer.city != null && customer.city!.isNotEmpty
                  ? 'Customer | ${customer.city}'
                  : 'Customer',
              footer: customer.createdDate != null
                  ? 'Created: ${customer.createdDate!.toLocal().toString().split(' ')[0]}'
                  : null,
              imageWidget: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(16),
                child: AssetImageWidget(
                  assetPath: 'assets/icons/CUSTOMER.png',
                  width: 48,
                  height: 48,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            // Customer Information Section
            DetailSection(
              type: DetailSectionType.infoList,
              title: 'Customer Information',
              items: [
                if (customer.contactEmail != null &&
                    customer.contactEmail!.isNotEmpty)
                  DetailItem(label: 'Email', value: customer.contactEmail!),
                if (customer.contactPhone != null &&
                    customer.contactPhone!.isNotEmpty)
                  DetailItem(label: 'Phone', value: customer.contactPhone!),
                if (customer.city != null && customer.city!.isNotEmpty)
                  DetailItem(label: 'City', value: customer.city!),
                if (customer.address != null && customer.address!.isNotEmpty)
                  DetailItem(label: 'Address', value: customer.address!),
                if (customer.createdDate != null)
                  DetailItem(
                    label: 'Created Date',
                    value: customer.createdDate!.toLocal().toString().split(
                      ' ',
                    )[0],
                  ),
              ],
            ),
          ],
          actionButtonLabel: 'Edit Customer',
          actionButtonColor: const Color(0xFF2563EB),
          onActionPressed: () {
            Navigator.of(context).pop();
            _navigateToEditCustomer(customer);
          },
        ),
      ),
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
      await ref
          .read(customerControllerProvider.notifier)
          .deleteCustomer(customerId);
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
      pageIconAsset: 'assets/icons/CUSTOMER.png',
      iconBackgroundColor: const Color(0xFFF3E8FF), // bg-purple-100
      searchController: _searchController,
      showSearchInHeader: true, // Show search in page header
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

  Widget _buildContent(
    List<Customer> customers,
    bool isLoading,
    String? error,
  ) {
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
      padding: EdgeInsets.zero, // No padding for end-to-end cards
      itemCount: customers.length,
      itemBuilder: (context, index) {
        final customer = customers[index];
        final fields = <CardField>[];
        if (customer.contactEmail != null) {
          fields.add(CardField(label: 'Email', value: customer.contactEmail!));
        }
        if (customer.contactPhone != null) {
          fields.add(CardField(label: 'Phone', value: customer.contactPhone!));
        }
        if (customer.city != null) {
          fields.add(CardField(label: 'City', value: customer.city!));
        }
        if (customer.address != null) {
          fields.add(CardField(label: 'Address', value: customer.address!));
        }

        return UnifiedListCardWidget(
          id: 'CUST-${customer.customerId ?? index + 1}',
          title: customer.name,
          fields: fields,
          onEdit: () => _navigateToEditCustomer(customer),
          onDelete: () => _deleteCustomer(customer.customerId!),
          onSend: () => _showCustomerDetail(customer),
          sendButtonLabel: 'View Details',
        );
      },
    );
  }
}
