import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/house.dart';
import '../../domain/usecases/create_house_usecase.dart';
import '../../domain/usecases/delete_house_usecase.dart';
import '../../domain/usecases/get_houses_usecase.dart';
import '../../domain/usecases/update_house_usecase.dart';
import '../providers/dashboard_providers.dart';
import '../states/house_state.dart';

class HouseController extends StateNotifier<HouseState> {
  final GetHousesUseCase getHousesUseCase;
  final CreateHouseUseCase createHouseUseCase;
  final UpdateHouseUseCase updateHouseUseCase;
  final DeleteHouseUseCase deleteHouseUseCase;
  final String userId;
  final String farmId;
  final Ref ref;

  HouseController({
    required this.getHousesUseCase,
    required this.createHouseUseCase,
    required this.updateHouseUseCase,
    required this.deleteHouseUseCase,
    required this.userId,
    required this.farmId,
    required this.ref,
  }) : super(const HouseState()) {
    loadHouses();
  }

  Future<void> loadHouses() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final houses = await getHousesUseCase(userId, farmId);
      state = state.copyWith(houses: houses, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }

  Future<bool> createHouse(House house) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await createHouseUseCase(house);
      await loadHouses();
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

  Future<bool> updateHouse(House house) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await updateHouseUseCase(house);
      await loadHouses();
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

  Future<bool> deleteHouse(int id) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await deleteHouseUseCase(id, userId, farmId);
      await loadHouses();
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
