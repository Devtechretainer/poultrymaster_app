import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/providers/auth_providers.dart';
import '../../application/providers/dashboard_providers.dart';
import '../../data/datasources/house_datasource.dart';
import '../../data/repositories/house_repository_impl.dart';
import '../../domain/repositories/house_repository.dart';
import '../../domain/usecases/create_house_usecase.dart';
import '../../domain/usecases/delete_house_usecase.dart';
import '../../domain/usecases/get_houses_usecase.dart';
import '../../domain/usecases/get_house_usecase.dart';
import '../../domain/usecases/update_house_usecase.dart';
import '../controllers/house_controller.dart';
import '../states/house_state.dart';

final houseDataSourceProvider = Provider<HouseDataSource>((ref) {
  final dio = ref.watch(dioProvider);
  final baseUrl = ref.watch(baseUrlProvider);
  return HouseDataSource(dio: dio, baseUrl: baseUrl);
});

final houseRepositoryProvider = Provider<HouseRepository>((ref) {
  final dataSource = ref.watch(houseDataSourceProvider);
  final authState = ref.watch(authControllerProvider);

  return HouseRepositoryImpl(
    dataSource: dataSource,
    authToken: authState.user?.token,
  );
});

final getHousesUseCaseProvider = Provider<GetHousesUseCase>((ref) {
  final repository = ref.watch(houseRepositoryProvider);
  return GetHousesUseCase(repository);
});

final getHouseUseCaseProvider = Provider<GetHouseUseCase>((ref) {
  final repository = ref.watch(houseRepositoryProvider);
  return GetHouseUseCase(repository);
});

final createHouseUseCaseProvider = Provider<CreateHouseUseCase>((ref) {
  final repository = ref.watch(houseRepositoryProvider);
  return CreateHouseUseCase(repository);
});

final updateHouseUseCaseProvider = Provider<UpdateHouseUseCase>((ref) {
  final repository = ref.watch(houseRepositoryProvider);
  return UpdateHouseUseCase(repository);
});

final deleteHouseUseCaseProvider = Provider<DeleteHouseUseCase>((ref) {
  final repository = ref.watch(houseRepositoryProvider);
  return DeleteHouseUseCase(repository);
});

final houseControllerProvider =
    StateNotifierProvider<HouseController, HouseState>((ref) {
  final getHousesUseCase = ref.watch(getHousesUseCaseProvider);
  final createHouseUseCase = ref.watch(createHouseUseCaseProvider);
  final updateHouseUseCase = ref.watch(updateHouseUseCaseProvider);
  final deleteHouseUseCase = ref.watch(deleteHouseUseCaseProvider);
  final authState = ref.watch(authControllerProvider);
  final userId = authState.user?.id ?? '';
  final farmId = authState.user?.farmId ?? authState.user?.id ?? '';

  return HouseController(
    getHousesUseCase: getHousesUseCase,
    createHouseUseCase: createHouseUseCase,
    updateHouseUseCase: updateHouseUseCase,
    deleteHouseUseCase: deleteHouseUseCase,
    userId: userId,
    farmId: farmId,
    ref: ref,
  );
});
