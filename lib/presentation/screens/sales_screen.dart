import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/providers/sale_providers.dart';
import '../../domain/entities/sale.dart';
import '../widgets/base_page_screen.dart';
import '../widgets/empty_state_widget.dart';
import '../widgets/loading_widget.dart';
import '../widgets/unified_list_card_widget.dart';
import '../widgets/ereceipt_detail_widget.dart';
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
    final dateTime = sale.saleDate.toLocal();
    final dateStr = dateTime.toString().split(' ')[0];
    final timeStr = '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')} ${dateTime.hour >= 12 ? 'PM' : 'AM'}';
    
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EReceiptDetailWidget(
          title: 'Sale Details',
          sections: [
            // Item Card Section
            DetailSection(
              type: DetailSectionType.itemCard,
              title: sale.product,
              subtitle: 'Product | Qty: ${sale.quantity.toString().padLeft(2, '0')}',
              footer: 'by ${sale.customerName}',
              icon: Icons.shopping_bag_outlined,
            ),
            // Order Information Section
            DetailSection(
              type: DetailSectionType.infoList,
              title: 'Order Information',
              items: [
                DetailItem(
                  label: 'Order ID',
                  value: 'SALE-${sale.saleId}',
                ),
                DetailItem(
                  label: 'Order Type',
                  value: 'Sale',
                ),
                DetailItem(
                  label: 'Customer',
                  value: sale.customerName,
                ),
                DetailItem(
                  label: 'Order Date',
                  value: '$dateStr | $timeStr',
                ),
                if (sale.saleDescription != null &&
                    sale.saleDescription!.isNotEmpty)
                  DetailItem(
                    label: 'Description',
                    value: sale.saleDescription!,
                  ),
              ],
            ),
            // Payment Summary Section
            DetailSection(
              type: DetailSectionType.summary,
              title: 'Payment Summary',
              items: [
                DetailItem(
                  label: 'Sub Total',
                  value: 'GH₵${sale.totalAmount.toStringAsFixed(2)}',
                ),
                DetailItem(
                  label: 'Unit Price',
                  value: '+ GH₵${sale.unitPrice.toStringAsFixed(2)}',
                ),
                DetailItem(
                  label: 'Quantity',
                  value: '${sale.quantity}',
                ),
                DetailItem(
                  label: 'Payment Method',
                  value: sale.paymentMethod,
                ),
              ],
            ),
          ],
          actionButtonLabel: 'Edit Sale',
          actionButtonColor: const Color(0xFF2563EB),
          onActionPressed: () {
            Navigator.of(context).pop();
            _navigateToEditSale(sale);
          },
        ),
      ),
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
      showSearchInHeader: true, // Show search in page header
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
      padding: EdgeInsets.zero, // No padding for end-to-end cards
      itemCount: sales.length,
      itemBuilder: (context, index) {
        final sale = sales[index];
        return UnifiedListCardWidget(
          id: 'SALE-${sale.saleId}',
          title: sale.product,
          fields: [
            CardField(label: 'Customer', value: sale.customerName),
            CardField(label: 'Quantity', value: '${sale.quantity}'),
            CardField(
              label: 'Total Amount',
              value: 'GH₵${sale.totalAmount.toStringAsFixed(2)}',
            ),
            CardField(
              label: 'Date',
              value: sale.saleDate.toLocal().toString().split(' ')[0],
            ),
            CardField(label: 'Payment', value: sale.paymentMethod),
          ],
          onEdit: () => _navigateToEditSale(sale),
          onDelete: () => _deleteSale(sale.saleId),
          onSend: () => _showSaleDetail(sale),
          sendButtonLabel: 'View Details',
        );
      },
    );
  }
}
