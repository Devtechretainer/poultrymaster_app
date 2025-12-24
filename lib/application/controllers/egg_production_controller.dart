import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/egg_production.dart';
import '../../domain/usecases/create_egg_production_usecase.dart';
import '../../domain/usecases/delete_egg_production_usecase.dart';
import '../../domain/usecases/get_egg_productions_usecase.dart';
import '../../domain/usecases/update_egg_production_usecase.dart';
import '../providers/dashboard_providers.dart';
import '../states/egg_production_state.dart';

class EggProductionController extends StateNotifier<EggProductionState> {
  final GetEggProductionsUseCase getEggProductionsUseCase;
  final CreateEggProductionUseCase createEggProductionUseCase;
  final UpdateEggProductionUseCase updateEggProductionUseCase;
  final DeleteEggProductionUseCase deleteEggProductionUseCase;
  final String userId;
  final String farmId;
  final Ref ref;

  EggProductionController({
    required this.getEggProductionsUseCase,
    required this.createEggProductionUseCase,
    required this.updateEggProductionUseCase,
    required this.deleteEggProductionUseCase,
    required this.userId,
    required this.farmId,
    required this.ref,
  }) : super(const EggProductionState()) {
    loadEggProductions();
  }

  Future<void> loadEggProductions() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final productions = await getEggProductionsUseCase(userId, farmId);
      state = state.copyWith(eggProductions: productions, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }

  Future<bool> createEggProduction(EggProduction eggProduction) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await createEggProductionUseCase(eggProduction);
      await loadEggProductions();
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

  Future<bool> updateEggProduction(EggProduction eggProduction) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await updateEggProductionUseCase(eggProduction);
      await loadEggProductions();
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

  Future<bool> deleteEggProduction(int id) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await deleteEggProductionUseCase(id, userId, farmId);
      await loadEggProductions();
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
