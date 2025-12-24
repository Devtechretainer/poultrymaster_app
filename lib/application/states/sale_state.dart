import '../../domain/entities/sale.dart';

class SaleState {
  final List<Sale> sales;
  final bool isLoading;
  final String? error;

  const SaleState({
    this.sales = const [],
    this.isLoading = false,
    this.error,
  });

  SaleState copyWith({
    List<Sale>? sales,
    bool? isLoading,
    String? error,
  }) {
    return SaleState(
      sales: sales ?? this.sales,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}
