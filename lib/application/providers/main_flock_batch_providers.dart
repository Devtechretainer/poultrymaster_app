import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/providers/auth_providers.dart';
import '../../application/providers/dashboard_providers.dart';
import '../../data/datasources/main_flock_batch_datasource.dart';
import '../../data/repositories/main_flock_batch_repository_impl.dart';
import '../../domain/repositories/main_flock_batch_repository.dart';
import '../../domain/usecases/create_main_flock_batch_usecase.dart';
import '../../domain/usecases/delete_main_flock_batch_usecase.dart';
import '../../domain/usecases/get_main_flock_batches_usecase.dart';
import '../../domain/usecases/get_main_flock_batch_usecase.dart';
import '../../domain/usecases/update_main_flock_batch_usecase.dart';
import '../controllers/main_flock_batch_controller.dart';
import '../states/main_flock_batch_state.dart';

final mainFlockBatchDataSourceProvider = Provider<MainFlockBatchDataSource>((ref) {
  final dio = ref.watch(dioProvider);
  final baseUrl = ref.watch(baseUrlProvider);
  return MainFlockBatchDataSource(dio: dio, baseUrl: baseUrl);
});

final mainFlockBatchRepositoryProvider = Provider<MainFlockBatchRepository>((ref) {
  final dataSource = ref.watch(mainFlockBatchDataSourceProvider);
  final authState = ref.watch(authControllerProvider);

  return MainFlockBatchRepositoryImpl(
    dataSource: dataSource,
    authToken: authState.user?.token,
  );
});

final getMainFlockBatchesUseCaseProvider = Provider<GetMainFlockBatchesUseCase>((ref) {
  final repository = ref.watch(mainFlockBatchRepositoryProvider);
  return GetMainFlockBatchesUseCase(repository);
});

final getMainFlockBatchUseCaseProvider = Provider<GetMainFlockBatchUseCase>((ref) {
  final repository = ref.watch(mainFlockBatchRepositoryProvider);
  return GetMainFlockBatchUseCase(repository);
});

final createMainFlockBatchUseCaseProvider = Provider<CreateMainFlockBatchUseCase>((ref) {
  final repository = ref.watch(mainFlockBatchRepositoryProvider);
  return CreateMainFlockBatchUseCase(repository);
});

final updateMainFlockBatchUseCaseProvider = Provider<UpdateMainFlockBatchUseCase>((ref) {
  final repository = ref.watch(mainFlockBatchRepositoryProvider);
  return UpdateMainFlockBatchUseCase(repository);
});

final deleteMainFlockBatchUseCaseProvider = Provider<DeleteMainFlockBatchUseCase>((ref) {
  final repository = ref.watch(mainFlockBatchRepositoryProvider);
  return DeleteMainFlockBatchUseCase(repository);
});

final mainFlockBatchControllerProvider =
    StateNotifierProvider<MainFlockBatchController, MainFlockBatchState>((ref) {
  final getMainFlockBatchesUseCase = ref.watch(getMainFlockBatchesUseCaseProvider);
  final createMainFlockBatchUseCase = ref.watch(createMainFlockBatchUseCaseProvider);
  final updateMainFlockBatchUseCase = ref.watch(updateMainFlockBatchUseCaseProvider);
  final deleteMainFlockBatchUseCase = ref.watch(deleteMainFlockBatchUseCaseProvider);
  final authState = ref.watch(authControllerProvider);
  final userId = authState.user?.id ?? '';
  final farmId = authState.user?.farmId ?? authState.user?.id ?? '';

  return MainFlockBatchController(
    getMainFlockBatchesUseCase: getMainFlockBatchesUseCase,
    createMainFlockBatchUseCase: createMainFlockBatchUseCase,
    updateMainFlockBatchUseCase: updateMainFlockBatchUseCase,
    deleteMainFlockBatchUseCase: deleteMainFlockBatchUseCase,
    userId: userId,
    farmId: farmId,
    ref: ref,
  );
});
