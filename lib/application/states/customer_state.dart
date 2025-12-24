import '../../domain/entities/customer.dart';

/// Application state - Represents customer UI state
class CustomerState {
  final List<Customer> customers;
  final bool isLoading;
  final String? error;

  const CustomerState({
    this.customers = const [],
    this.isLoading = false,
    this.error,
  });

  /// Creates a copy with updated values
  CustomerState copyWith({
    List<Customer>? customers,
    bool? isLoading,
    String? error,
  }) {
    return CustomerState(
      customers: customers ?? this.customers,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}
