import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/flock_request.dart';
import '../../domain/usecases/create_flock_usecase.dart';
import '../../domain/usecases/delete_flock_usecase.dart';
import '../../domain/usecases/get_flocks_usecase.dart';
import '../../domain/usecases/update_flock_usecase.dart';
import '../providers/dashboard_providers.dart';
import '../states/flock_state.dart';

class FlockController extends StateNotifier<FlockState> {
  final GetFlocksUseCase getFlocksUseCase;
  final CreateFlockUseCase createFlockUseCase;
  final UpdateFlockUseCase updateFlockUseCase;
  final DeleteFlockUseCase deleteFlockUseCase;
  final String userId;
  final String farmId;
  final Ref ref;

  FlockController({
    required this.getFlocksUseCase,
    required this.createFlockUseCase,
    required this.updateFlockUseCase,
    required this.deleteFlockUseCase,
    required this.userId,
    required this.farmId,
    required this.ref,
  }) : super(const FlockState()) {
    loadFlocks();
  }

  Future<void> loadFlocks() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final flocks = await getFlocksUseCase(userId, farmId);
      state = state.copyWith(flocks: flocks, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }

  Future<bool> createFlock(FlockRequest flockRequest) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await createFlockUseCase(flockRequest);
      await loadFlocks();
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

  Future<bool> updateFlock(int flockId, FlockRequest flockRequest) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await updateFlockUseCase(flockId, flockRequest);
      await loadFlocks();
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

  Future<bool> deleteFlock(int flockId) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await deleteFlockUseCase(flockId, userId, farmId);
      await loadFlocks();
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
