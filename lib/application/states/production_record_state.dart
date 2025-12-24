import '../../domain/entities/production_record.dart';

class ProductionRecordState {
  final List<ProductionRecord> productionRecords;
  final bool isLoading;
  final String? error;

  const ProductionRecordState({
    this.productionRecords = const [],
    this.isLoading = false,
    this.error,
  });

  ProductionRecordState copyWith({
    List<ProductionRecord>? productionRecords,
    bool? isLoading,
    String? error,
  }) {
    return ProductionRecordState(
      productionRecords: productionRecords ?? this.productionRecords,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}
