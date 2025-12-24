import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/providers/auth_providers.dart';
import '../../application/providers/dashboard_providers.dart';
import '../../data/datasources/egg_production_datasource.dart';
import '../../data/repositories/egg_production_repository_impl.dart';
import '../../domain/repositories/egg_production_repository.dart';
import '../../domain/usecases/create_egg_production_usecase.dart';
import '../../domain/usecases/delete_egg_production_usecase.dart';
import '../../domain/usecases/get_egg_productions_usecase.dart';
import '../../domain/usecases/get_egg_production_usecase.dart';
import '../../domain/usecases/update_egg_production_usecase.dart';
import '../controllers/egg_production_controller.dart';
import '../states/egg_production_state.dart';

final eggProductionDataSourceProvider = Provider<EggProductionDataSource>((ref) {
  final dio = ref.watch(dioProvider);
  final baseUrl = ref.watch(baseUrlProvider);
  return EggProductionDataSource(dio: dio, baseUrl: baseUrl);
});

final eggProductionRepositoryProvider = Provider<EggProductionRepository>((ref) {
  final dataSource = ref.watch(eggProductionDataSourceProvider);
  final authState = ref.watch(authControllerProvider);

  return EggProductionRepositoryImpl(
    dataSource: dataSource,
    authToken: authState.user?.token,
  );
});

final getEggProductionsUseCaseProvider = Provider<GetEggProductionsUseCase>((ref) {
  final repository = ref.watch(eggProductionRepositoryProvider);
  return GetEggProductionsUseCase(repository);
});

final getEggProductionUseCaseProvider = Provider<GetEggProductionUseCase>((ref) {
  final repository = ref.watch(eggProductionRepositoryProvider);
  return GetEggProductionUseCase(repository);
});

final createEggProductionUseCaseProvider = Provider<CreateEggProductionUseCase>((ref) {
  final repository = ref.watch(eggProductionRepositoryProvider);
  return CreateEggProductionUseCase(repository);
});

final updateEggProductionUseCaseProvider = Provider<UpdateEggProductionUseCase>((ref) {
  final repository = ref.watch(eggProductionRepositoryProvider);
  return UpdateEggProductionUseCase(repository);
});

final deleteEggProductionUseCaseProvider = Provider<DeleteEggProductionUseCase>((ref) {
  final repository = ref.watch(eggProductionRepositoryProvider);
  return DeleteEggProductionUseCase(repository);
});

final eggProductionControllerProvider =
    StateNotifierProvider<EggProductionController, EggProductionState>((ref) {
  final getEggProductionsUseCase = ref.watch(getEggProductionsUseCaseProvider);
  final createEggProductionUseCase = ref.watch(createEggProductionUseCaseProvider);
  final updateEggProductionUseCase = ref.watch(updateEggProductionUseCaseProvider);
  final deleteEggProductionUseCase = ref.watch(deleteEggProductionUseCaseProvider);
  final authState = ref.watch(authControllerProvider);
  final userId = authState.user?.id ?? '';
  final farmId = authState.user?.farmId ?? authState.user?.id ?? '';

  return EggProductionController(
    getEggProductionsUseCase: getEggProductionsUseCase,
    createEggProductionUseCase: createEggProductionUseCase,
    updateEggProductionUseCase: updateEggProductionUseCase,
    deleteEggProductionUseCase: deleteEggProductionUseCase,
    userId: userId,
    farmId: farmId,
    ref: ref,
  );
});
