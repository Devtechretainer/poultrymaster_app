import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/providers/auth_providers.dart';
import '../../application/providers/dashboard_providers.dart';
import '../../data/datasources/flock_datasource.dart';
import '../../data/repositories/flock_repository_impl.dart';
import '../../domain/repositories/flock_repository.dart';
import '../../domain/usecases/create_flock_usecase.dart';
import '../../domain/usecases/delete_flock_usecase.dart';
import '../../domain/usecases/get_flock_usecase.dart';
import '../../domain/usecases/get_flocks_usecase.dart';
import '../../domain/usecases/update_flock_usecase.dart';
import '../controllers/flock_controller.dart';
import '../states/flock_state.dart';

final flockDataSourceProvider = Provider<FlockDataSource>((ref) {
  final dio = ref.watch(dioProvider);
  final baseUrl = ref.watch(baseUrlProvider);
  return FlockDataSource(dio: dio, baseUrl: baseUrl);
});

final flockRepositoryProvider = Provider<FlockRepository>((ref) {
  final dataSource = ref.watch(flockDataSourceProvider);
  final authState = ref.watch(authControllerProvider);

  return FlockRepositoryImpl(
    dataSource: dataSource,
    authToken: authState.user?.token,
  );
});

final getFlocksUseCaseProvider = Provider<GetFlocksUseCase>((ref) {
  final repository = ref.watch(flockRepositoryProvider);
  return GetFlocksUseCase(repository);
});

final getFlockUseCaseProvider = Provider<GetFlockUseCase>((ref) {
  final repository = ref.watch(flockRepositoryProvider);
  return GetFlockUseCase(repository);
});

final createFlockUseCaseProvider = Provider<CreateFlockUseCase>((ref) {
  final repository = ref.watch(flockRepositoryProvider);
  return CreateFlockUseCase(repository);
});

final updateFlockUseCaseProvider = Provider<UpdateFlockUseCase>((ref) {
  final repository = ref.watch(flockRepositoryProvider);
  return UpdateFlockUseCase(repository);
});

final deleteFlockUseCaseProvider = Provider<DeleteFlockUseCase>((ref) {
  final repository = ref.watch(flockRepositoryProvider);
  return DeleteFlockUseCase(repository);
});

final flockControllerProvider =
    StateNotifierProvider<FlockController, FlockState>((ref) {
  final getFlocksUseCase = ref.watch(getFlocksUseCaseProvider);
  final createFlockUseCase = ref.watch(createFlockUseCaseProvider);
  final updateFlockUseCase = ref.watch(updateFlockUseCaseProvider);
  final deleteFlockUseCase = ref.watch(deleteFlockUseCaseProvider);
  final authState = ref.watch(authControllerProvider);
  final userId = authState.user?.id ?? '';
  final farmId = authState.user?.farmId ?? authState.user?.id ?? '';

  return FlockController(
    getFlocksUseCase: getFlocksUseCase,
    createFlockUseCase: createFlockUseCase,
    updateFlockUseCase: updateFlockUseCase,
    deleteFlockUseCase: deleteFlockUseCase,
    userId: userId,
    farmId: farmId,
    ref: ref,
  );
});
