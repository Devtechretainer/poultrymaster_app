import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/sale.dart';
import '../../domain/usecases/create_sale_usecase.dart';
import '../../domain/usecases/delete_sale_usecase.dart';
import '../../domain/usecases/get_sales_by_flock_id_usecase.dart';
import '../../domain/usecases/get_sales_usecase.dart';
import '../../domain/usecases/update_sale_usecase.dart';
import '../providers/dashboard_providers.dart';
import '../states/sale_state.dart';

class SaleController extends StateNotifier<SaleState> {
  final GetSalesUseCase getSalesUseCase;
  final GetSalesByFlockIdUseCase getSalesByFlockIdUseCase;
  final CreateSaleUseCase createSaleUseCase;
  final UpdateSaleUseCase updateSaleUseCase;
  final DeleteSaleUseCase deleteSaleUseCase;
  final String userId;
  final String farmId;
  final Ref ref;

  SaleController({
    required this.getSalesUseCase,
    required this.getSalesByFlockIdUseCase,
    required this.createSaleUseCase,
    required this.updateSaleUseCase,
    required this.deleteSaleUseCase,
    required this.userId,
    required this.farmId,
    required this.ref,
  }) : super(const SaleState()) {
    loadSales();
  }

  Future<void> loadSales() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final sales = await getSalesUseCase(userId, farmId);
      state = state.copyWith(sales: sales, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }

  Future<List<Sale>> loadSalesByFlockId(int flockId) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final sales = await getSalesByFlockIdUseCase(flockId, userId, farmId);
      state = state.copyWith(isLoading: false);
      return sales;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString().replaceAll('Exception: ', ''),
      );
      return [];
    }
  }

  Future<bool> createSale(Sale sale) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await createSaleUseCase(sale);
      await loadSales();
      ref.invalidate(dashboardControllerProvider(farmId));
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString().replaceAll('Exception: ', ''),
      );
      return false;
    }
  }

  Future<bool> updateSale(Sale sale) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await updateSaleUseCase(sale);
      await loadSales();
      ref.invalidate(dashboardControllerProvider(farmId));
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString().replaceAll('Exception: ', ''),
      );
      return false;
    }
  }

  Future<bool> deleteSale(int id) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await deleteSaleUseCase(id, userId, farmId);
      await loadSales();
      ref.invalidate(dashboardControllerProvider(farmId));
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString().replaceAll('Exception: ', ''),
      );
      return false;
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}
