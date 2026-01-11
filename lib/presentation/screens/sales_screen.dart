import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/providers/sale_providers.dart';
import '../../domain/entities/sale.dart';
import '../widgets/base_page_screen.dart';
import '../widgets/empty_state_widget.dart';
import '../widgets/info_item_widget.dart';
import '../widgets/loading_widget.dart';
import 'add_edit_sale_screen.dart';

class SalesScreen extends ConsumerStatefulWidget {
  final Function(String) onNavigate;
  final VoidCallback onLogout;

  const SalesScreen({
    super.key,
    required this.onNavigate,
    required this.onLogout,
  });

  @override
  ConsumerState<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends ConsumerState<SalesScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(saleControllerProvider.notifier).loadSales();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _navigateToAddSale() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const AddEditSaleScreen()));
  }

  void _showSaleDetail(Sale sale) {
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
                          'Sale Details',
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
                    icon: Icons.shopping_bag_outlined,
                    label: 'Product',
                    value: sale.product,
                  ),
                  const SizedBox(height: 16),
                  InfoItemWidget(
                    icon: Icons.person_outline,
                    label: 'Customer',
                    value: sale.customerName,
                  ),
                  const SizedBox(height: 16),
                  InfoItemWidget(
                    icon: Icons.numbers_outlined,
                    label: 'Quantity',
                    value: '${sale.quantity}',
                  ),
                  const SizedBox(height: 16),
                  InfoItemWidget(
                    icon: Icons.attach_money_outlined,
                    label: 'Unit Price',
                    value: 'GH₵${sale.unitPrice.toStringAsFixed(2)}',
                  ),
                  const SizedBox(height: 16),
                  InfoItemWidget(
                    icon: Icons.attach_money_outlined,
                    label: 'Total Amount',
                    value: 'GH₵${sale.totalAmount.toStringAsFixed(2)}',
                  ),
                  const SizedBox(height: 16),
                  InfoItemWidget(
                    icon: Icons.calendar_today_outlined,
                    label: 'Date',
                    value: sale.saleDate.toLocal().toString().split(' ')[0],
                  ),
                  const SizedBox(height: 16),
                  InfoItemWidget(
                    icon: Icons.payment_outlined,
                    label: 'Payment Method',
                    value: sale.paymentMethod,
                  ),
                  if (sale.saleDescription != null &&
                      sale.saleDescription!.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    InfoItemWidget(
                      icon: Icons.description_outlined,
                      label: 'Description',
                      value: sale.saleDescription!,
                    ),
                  ],
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _navigateToEditSale(sale);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2563EB),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Edit Sale'),
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

  void _navigateToEditSale(Sale sale) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => AddEditSaleScreen(sale: sale)));
  }

  Future<void> _deleteSale(int id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Deletion'),
        content: const Text(
          'Are you sure you want to delete this sale record?',
        ),
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
      await ref.read(saleControllerProvider.notifier).deleteSale(id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final saleState = ref.watch(saleControllerProvider);
    final sales = saleState.sales;
    final isLoading = saleState.isLoading;
    final error = saleState.error;

    return BasePageScreen(
      currentRoute: '/sales',
      onNavigate: widget.onNavigate,
      onLogout: widget.onLogout,
      pageTitle: 'Sales',
      pageSubtitle: 'Track your sales transactions',
      pageIcon: Icons.shopping_bag,
      iconBackgroundColor: const Color(0xFFECFDF5),
      searchController: _searchController,
      actionButton: ElevatedButton.icon(
        onPressed: _navigateToAddSale,
        icon: const Icon(Icons.add, color: Colors.white, size: 16),
        label: const Text(
          'Add Sale',
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2563EB),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      child: _buildContent(sales, isLoading, error),
    );
  }

  Widget _buildContent(List<Sale> sales, bool isLoading, String? error) {
    if (isLoading) {
      return const Padding(
        padding: EdgeInsets.all(32.0),
        child: LoadingWidget.large(),
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
                  ref.read(saleControllerProvider.notifier).loadSales();
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (sales.isEmpty) {
      return EmptyStateWidget(
        icon: Icons.shopping_bag,
        title: 'No sales records found',
        subtitle: 'Start tracking sales by adding your first transaction',
        buttonLabel: 'Add Your First Sale',
        onButtonPressed: _navigateToAddSale,
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: sales.length,
      itemBuilder: (context, index) {
        final sale = sales[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _SaleCard(
            sale: sale,
            index: index + 1,
            onViewDetail: () => _showSaleDetail(sale),
            onEdit: () => _navigateToEditSale(sale),
            onDelete: () => _deleteSale(sale.saleId),
          ),
        );
      },
    );
  }
}

/// Sale Card Widget - Card-based design
class _SaleCard extends StatelessWidget {
  final Sale sale;
  final int index;
  final VoidCallback onViewDetail;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _SaleCard({
    required this.sale,
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
                    sale.product,
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
            _InfoItem(
              icon: Icons.person_outline,
              label: 'Customer',
              value: sale.customerName,
            ),
            const SizedBox(height: 12),
            _InfoItem(
              icon: Icons.numbers_outlined,
              label: 'Quantity',
              value: '${sale.quantity}',
            ),
            const SizedBox(height: 12),
            _InfoItem(
              icon: Icons.attach_money_outlined,
              label: 'Total Amount',
              value: 'GH₵${sale.totalAmount.toStringAsFixed(2)}',
            ),
            const SizedBox(height: 12),
            _InfoItem(
              icon: Icons.calendar_today_outlined,
              label: 'Date',
              value: sale.saleDate.toLocal().toString().split(' ')[0],
            ),
            const SizedBox(height: 12),
            _InfoItem(
              icon: Icons.payment_outlined,
              label: 'Payment',
              value: sale.paymentMethod,
            ),
            const SizedBox(height: 16),
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
        Icon(icon, size: 18, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
