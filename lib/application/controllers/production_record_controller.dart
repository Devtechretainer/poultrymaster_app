import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/production_record.dart';
import '../../domain/usecases/create_production_record_usecase.dart';
import '../../domain/usecases/delete_production_record_usecase.dart';
import '../../domain/usecases/get_production_records_usecase.dart';
import '../../domain/usecases/update_production_record_usecase.dart';
import '../providers/dashboard_providers.dart';
import '../states/production_record_state.dart';

class ProductionRecordController extends StateNotifier<ProductionRecordState> {
  final GetProductionRecordsUseCase getProductionRecordsUseCase;
  final CreateProductionRecordUseCase createProductionRecordUseCase;
  final UpdateProductionRecordUseCase updateProductionRecordUseCase;
  final DeleteProductionRecordUseCase deleteProductionRecordUseCase;
  final String userId;
  final String farmId;
  final Ref ref;

  ProductionRecordController({
    required this.getProductionRecordsUseCase,
    required this.createProductionRecordUseCase,
    required this.updateProductionRecordUseCase,
    required this.deleteProductionRecordUseCase,
    required this.userId,
    required this.farmId,
    required this.ref,
  }) : super(const ProductionRecordState()) {
    loadProductionRecords();
  }

  Future<void> loadProductionRecords() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final records = await getProductionRecordsUseCase(userId, farmId);
      state = state.copyWith(productionRecords: records, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }

  Future<bool> createProductionRecord(ProductionRecord productionRecord) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await createProductionRecordUseCase(productionRecord);
      await loadProductionRecords();
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

  Future<bool> updateProductionRecord(ProductionRecord productionRecord) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await updateProductionRecordUseCase(productionRecord);
      await loadProductionRecords();
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

  Future<bool> deleteProductionRecord(int id) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await deleteProductionRecordUseCase(id, userId, farmId);
      await loadProductionRecords();
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
