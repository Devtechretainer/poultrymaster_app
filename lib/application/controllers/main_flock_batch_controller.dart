import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/flock_batch_request.dart';
import '../../domain/entities/main_flock_batch.dart';
import '../../domain/usecases/create_main_flock_batch_usecase.dart';
import '../../domain/usecases/delete_main_flock_batch_usecase.dart';
import '../../domain/usecases/get_main_flock_batches_usecase.dart';
import '../../domain/usecases/update_main_flock_batch_usecase.dart';
import '../providers/dashboard_providers.dart';
import '../states/main_flock_batch_state.dart';

class MainFlockBatchController extends StateNotifier<MainFlockBatchState> {
  final GetMainFlockBatchesUseCase getMainFlockBatchesUseCase;
  final CreateMainFlockBatchUseCase createMainFlockBatchUseCase;
  final UpdateMainFlockBatchUseCase updateMainFlockBatchUseCase;
  final DeleteMainFlockBatchUseCase deleteMainFlockBatchUseCase;
  final String userId;
  final String farmId;
  final Ref ref;

  MainFlockBatchController({
    required this.getMainFlockBatchesUseCase,
    required this.createMainFlockBatchUseCase,
    required this.updateMainFlockBatchUseCase,
    required this.deleteMainFlockBatchUseCase,
    required this.userId,
    required this.farmId,
    required this.ref,
  }) : super(const MainFlockBatchState()) {
    loadMainFlockBatches();
  }

  Future<void> loadMainFlockBatches() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final mainFlockBatches =
          await getMainFlockBatchesUseCase(userId, farmId);
      state = state.copyWith(
          mainFlockBatches: mainFlockBatches, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }

  Future<bool> createMainFlockBatch(FlockBatchRequest flockBatchRequest) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await createMainFlockBatchUseCase(flockBatchRequest);
      await loadMainFlockBatches();
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

  Future<bool> updateMainFlockBatch(int batchId, FlockBatchRequest flockBatchRequest) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await updateMainFlockBatchUseCase(batchId, flockBatchRequest);
      await loadMainFlockBatches();
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

  Future<bool> deleteMainFlockBatch(int batchId) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await deleteMainFlockBatchUseCase(batchId, userId, farmId);
      await loadMainFlockBatches();
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
