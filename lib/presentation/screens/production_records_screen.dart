import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/providers/production_record_providers.dart';
import '../../application/providers/egg_production_providers.dart';
import '../../domain/entities/production_record.dart';
import '../../domain/entities/egg_production.dart';
import '../widgets/base_page_screen.dart';
import '../widgets/empty_state_widget.dart';
import '../widgets/loading_widget.dart';
import '../widgets/unified_list_card_widget.dart';
import '../widgets/ereceipt_detail_widget.dart';
import '../widgets/asset_image_widget.dart';
import 'add_edit_production_record_screen.dart';
import 'add_edit_egg_production_screen.dart';

class ProductionRecordsScreen extends ConsumerStatefulWidget {
  final Function(String) onNavigate;
  final VoidCallback onLogout;

  const ProductionRecordsScreen({
    super.key,
    required this.onNavigate,
    required this.onLogout,
  });

  @override
  ConsumerState<ProductionRecordsScreen> createState() =>
      _ProductionRecordsScreenState();
}

class _ProductionRecordsScreenState
    extends ConsumerState<ProductionRecordsScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(productionRecordControllerProvider.notifier)
          .loadProductionRecords();
      ref
          .read(eggProductionControllerProvider.notifier)
          .loadEggProductions();
    });
  }

  void _showEggProductionDetail(EggProduction eggProduction) {
    final dateTime = eggProduction.productionDate.toLocal();
    final dateStr = dateTime.toString().split(' ')[0];
    final timeStr =
        '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')} ${dateTime.hour >= 12 ? 'PM' : 'AM'}';

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EReceiptDetailWidget(
          title: 'Production Details',
          sections: [
            // Item Card Section
            DetailSection(
              type: DetailSectionType.itemCard,
              title: 'Flock ${eggProduction.flockId}',
              subtitle:
                  'Egg Production | Total: ${eggProduction.totalProduction} eggs',
              footer: 'Production Date: $dateStr',
              imageWidget: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(16),
                child: AssetImageWidget(
                  assetPath: 'assets/icons/egg.png',
                  width: 48,
                  height: 48,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            // Production Information Section
            DetailSection(
              type: DetailSectionType.infoList,
              title: 'Production Information',
              items: [
                DetailItem(
                  label: 'Production ID',
                  value: 'EGG-${eggProduction.productionId}',
                ),
                DetailItem(
                  label: 'Flock ID',
                  value: '${eggProduction.flockId}',
                ),
                DetailItem(
                  label: 'Production Date',
                  value: '$dateStr | $timeStr',
                ),
                if (eggProduction.notes != null &&
                    eggProduction.notes!.isNotEmpty)
                  DetailItem(label: 'Notes', value: eggProduction.notes!),
              ],
            ),
            // Production Summary Section
            DetailSection(
              type: DetailSectionType.summary,
              title: 'Production Summary',
              items: [
                DetailItem(
                  label: 'Total Production',
                  value: '${eggProduction.totalProduction} eggs',
                ),
                DetailItem(
                  label: '9 AM Production',
                  value: '+ ${eggProduction.production9AM} eggs',
                ),
                DetailItem(
                  label: '12 PM Production',
                  value: '+ ${eggProduction.production12PM} eggs',
                ),
                DetailItem(
                  label: '4 PM Production',
                  value: '+ ${eggProduction.production4PM} eggs',
                ),
                DetailItem(
                  label: 'Broken Eggs',
                  value: '- ${eggProduction.brokenEggs}',
                ),
                DetailItem(
                  label: 'Egg Count',
                  value: '${eggProduction.eggCount}',
                ),
              ],
            ),
          ],
          actionButtonLabel: 'Edit Egg Production',
          actionButtonColor: const Color(0xFF2563EB),
          onActionPressed: () {
            Navigator.of(context).pop();
            _navigateToEditEggProduction(eggProduction);
          },
        ),
      ),
    );
  }

  void _navigateToEditEggProduction(EggProduction eggProduction) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) =>
            AddEditEggProductionScreen(eggProduction: eggProduction),
      ),
    );
  }

  Future<void> _deleteEggProduction(int id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Deletion'),
        content: const Text(
          'Are you sure you want to delete this egg production record?',
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
      await ref
          .read(eggProductionControllerProvider.notifier)
          .deleteEggProduction(id);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _navigateToAddProductionRecord() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const AddEditProductionRecordScreen()),
    );
  }

  void _showProductionRecordDetail(ProductionRecord productionRecord) {
    final dateTime = productionRecord.date.toLocal();
    final dateStr = dateTime.toString().split(' ')[0];
    final timeStr =
        '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')} ${dateTime.hour >= 12 ? 'PM' : 'AM'}';

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EReceiptDetailWidget(
          title: 'Production Details',
          sections: [
            // Item Card Section
            DetailSection(
              type: DetailSectionType.itemCard,
              title: 'Flock ${productionRecord.flockId}',
              subtitle:
                  'Production Record | Total: ${productionRecord.totalProduction} eggs',
              footer: 'Production Date: $dateStr',
              imageWidget: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(16),
                child: AssetImageWidget(
                  assetPath: 'assets/icons/egg.png',
                  width: 48,
                  height: 48,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            // Production Information Section
            DetailSection(
              type: DetailSectionType.infoList,
              title: 'Production Information',
              items: [
                DetailItem(
                  label: 'Record ID',
                  value: 'PROD-${productionRecord.id}',
                ),
                DetailItem(
                  label: 'Flock ID',
                  value: '${productionRecord.flockId}',
                ),
                DetailItem(
                  label: 'Production Date',
                  value: '$dateStr | $timeStr',
                ),
                DetailItem(
                  label: 'Age in Weeks',
                  value: '${productionRecord.ageInWeeks} weeks',
                ),
                DetailItem(
                  label: 'Age in Days',
                  value: '${productionRecord.ageInDays} days',
                ),
                DetailItem(
                  label: 'Number of Birds',
                  value: '${productionRecord.noOfBirds} birds',
                ),
                DetailItem(
                  label: 'Birds Left',
                  value: '${productionRecord.noOfBirdsLeft} birds',
                ),
                DetailItem(
                  label: 'Mortality',
                  value: '${productionRecord.mortality} birds',
                ),
                DetailItem(
                  label: 'Feed',
                  value: '${productionRecord.feedKg} Kg',
                ),
                if (productionRecord.medication != null &&
                    productionRecord.medication!.isNotEmpty)
                  DetailItem(
                    label: 'Medication',
                    value: productionRecord.medication!,
                  ),
              ],
            ),
            // Production Summary Section
            DetailSection(
              type: DetailSectionType.summary,
              title: 'Production Summary',
              items: [
                DetailItem(
                  label: 'Total Production',
                  value: '${productionRecord.totalProduction} eggs',
                ),
                DetailItem(
                  label: '9 AM Production',
                  value: '+ ${productionRecord.production9AM} eggs',
                ),
                DetailItem(
                  label: '12 PM Production',
                  value: '+ ${productionRecord.production12PM} eggs',
                ),
                DetailItem(
                  label: '4 PM Production',
                  value: '+ ${productionRecord.production4PM} eggs',
                ),
              ],
            ),
          ],
          actionButtonLabel: 'Edit Production Record',
          actionButtonColor: const Color(0xFF2563EB),
          onActionPressed: () {
            Navigator.of(context).pop();
            _navigateToEditProductionRecord(productionRecord);
          },
        ),
      ),
    );
  }

  void _navigateToEditProductionRecord(ProductionRecord productionRecord) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) =>
            AddEditProductionRecordScreen(productionRecord: productionRecord),
      ),
    );
  }

  Future<void> _deleteProductionRecord(int id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Deletion'),
        content: const Text(
          'Are you sure you want to delete this production record?',
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
      await ref
          .read(productionRecordControllerProvider.notifier)
          .deleteProductionRecord(id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final productionRecordState = ref.watch(productionRecordControllerProvider);
    final eggProductionState = ref.watch(eggProductionControllerProvider);
    final productionRecords = productionRecordState.productionRecords;
    final eggProductions = eggProductionState.eggProductions;
    final isLoading = productionRecordState.isLoading || eggProductionState.isLoading;
    final error = productionRecordState.error ?? eggProductionState.error;

    return BasePageScreen(
      currentRoute: '/production-records',
      onNavigate: widget.onNavigate,
      onLogout: widget.onLogout,
      pageTitle: 'Production Records',
      pageSubtitle: 'Track your farm production',
      pageIcon: Icons.description,
      iconBackgroundColor: const Color(0xFFFEF3C7),
      searchController: _searchController,
      showSearchInHeader: true,
      actionButton: ElevatedButton.icon(
        onPressed: _navigateToAddProductionRecord,
        icon: const Icon(Icons.add, color: Colors.white, size: 16),
        label: const Text(
          'Log Production',
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2563EB),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      child: _buildContent(productionRecords, eggProductions, isLoading, error),
    );
  }

  Widget _buildContent(
    List<ProductionRecord> productionRecords,
    List<EggProduction> eggProductions,
    bool isLoading,
    String? error,
  ) {
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
                  ref
                      .read(productionRecordControllerProvider.notifier)
                      .loadProductionRecords();
                  ref
                      .read(eggProductionControllerProvider.notifier)
                      .loadEggProductions();
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (productionRecords.isEmpty && eggProductions.isEmpty) {
      return EmptyStateWidget(
        icon: Icons.description,
        title: 'No production records found',
        subtitle: 'Start tracking your production by logging your first record',
        buttonLabel: 'Log Your First Production',
        onButtonPressed: _navigateToAddProductionRecord,
      );
    }

    // Combine both lists - Production Records first, then Egg Productions
    // Sort by date descending (most recent first)
    final allRecords = <_ProductionItem>[];
    
    // Add production records
    for (var record in productionRecords) {
      allRecords.add(_ProductionItem(
        type: _ProductionType.productionRecord,
        productionRecord: record,
        date: record.date,
      ));
    }
    
    // Add egg productions
    for (var egg in eggProductions) {
      allRecords.add(_ProductionItem(
        type: _ProductionType.eggProduction,
        eggProduction: egg,
        date: egg.productionDate,
      ));
    }
    
    // Sort by date (most recent first)
    allRecords.sort((a, b) => b.date.compareTo(a.date));

    return ListView.builder(
      padding: EdgeInsets.zero, // End-to-end cards
      itemCount: allRecords.length,
      itemBuilder: (context, index) {
        final item = allRecords[index];
        
        if (item.type == _ProductionType.productionRecord) {
          final record = item.productionRecord!;
          return UnifiedListCardWidget(
            id: 'PROD-${record.id}',
            title: 'Flock ${record.flockId}',
            fields: [
              CardField(
                label: 'Date',
                value: record.date.toLocal().toString().split(' ')[0],
              ),
              CardField(label: 'Production', value: '${record.totalProduction} eggs'),
              CardField(label: 'Mortality', value: '${record.mortality} birds'),
              CardField(label: 'Feed', value: '${record.feedKg} Kg'),
              CardField(label: 'Birds Left', value: '${record.noOfBirdsLeft}'),
            ],
            onEdit: () => _navigateToEditProductionRecord(record),
            onDelete: () => _deleteProductionRecord(record.id),
            onSend: () => _showProductionRecordDetail(record),
            sendButtonLabel: 'View Details',
          );
        } else {
          final egg = item.eggProduction!;
          final fields = <CardField>[
            CardField(
              label: 'Date',
              value: egg.productionDate.toLocal().toString().split(' ')[0],
            ),
            CardField(
              label: 'Total Production',
              value: '${egg.totalProduction} eggs',
            ),
            CardField(label: 'Broken Eggs', value: '${egg.brokenEggs}'),
          ];
          if (egg.notes != null && egg.notes!.isNotEmpty) {
            fields.add(CardField(label: 'Notes', value: egg.notes!));
          }

          return UnifiedListCardWidget(
            id: 'EGG-${egg.productionId}',
            title: 'Flock ${egg.flockId}',
            fields: fields,
            onEdit: () => _navigateToEditEggProduction(egg),
            onDelete: () => _deleteEggProduction(egg.productionId),
            onSend: () => _showEggProductionDetail(egg),
            sendButtonLabel: 'View Details',
          );
        }
      },
    );
  }
}

// Helper class to combine both types of production records
enum _ProductionType {
  productionRecord,
  eggProduction,
}

class _ProductionItem {
  final _ProductionType type;
  final ProductionRecord? productionRecord;
  final EggProduction? eggProduction;
  final DateTime date;

  _ProductionItem({
    required this.type,
    this.productionRecord,
    this.eggProduction,
    required this.date,
  });
}
