import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/providers/auth_providers.dart';
import '../../application/providers/dashboard_providers.dart';
import '../../data/datasources/production_record_datasource.dart';
import '../../data/repositories/production_record_repository_impl.dart';
import '../../domain/repositories/production_record_repository.dart';
import '../../domain/usecases/create_production_record_usecase.dart';
import '../../domain/usecases/delete_production_record_usecase.dart';
import '../../domain/usecases/get_production_records_usecase.dart';
import '../../domain/usecases/get_production_record_usecase.dart';
import '../../domain/usecases/update_production_record_usecase.dart';
import '../controllers/production_record_controller.dart';
import '../states/production_record_state.dart';

final productionRecordDataSourceProvider = Provider<ProductionRecordDataSource>((ref) {
  final dio = ref.watch(dioProvider);
  final baseUrl = ref.watch(baseUrlProvider);
  return ProductionRecordDataSource(dio: dio, baseUrl: baseUrl);
});

final productionRecordRepositoryProvider = Provider<ProductionRecordRepository>((ref) {
  final dataSource = ref.watch(productionRecordDataSourceProvider);
  final authState = ref.watch(authControllerProvider);

  return ProductionRecordRepositoryImpl(
    dataSource: dataSource,
    authToken: authState.user?.token,
  );
});

final getProductionRecordsUseCaseProvider = Provider<GetProductionRecordsUseCase>((ref) {
  final repository = ref.watch(productionRecordRepositoryProvider);
  return GetProductionRecordsUseCase(repository);
});

final getProductionRecordUseCaseProvider = Provider<GetProductionRecordUseCase>((ref) {
  final repository = ref.watch(productionRecordRepositoryProvider);
  return GetProductionRecordUseCase(repository);
});

final createProductionRecordUseCaseProvider = Provider<CreateProductionRecordUseCase>((ref) {
  final repository = ref.watch(productionRecordRepositoryProvider);
  return CreateProductionRecordUseCase(repository);
});

final updateProductionRecordUseCaseProvider = Provider<UpdateProductionRecordUseCase>((ref) {
  final repository = ref.watch(productionRecordRepositoryProvider);
  return UpdateProductionRecordUseCase(repository);
});

final deleteProductionRecordUseCaseProvider = Provider<DeleteProductionRecordUseCase>((ref) {
  final repository = ref.watch(productionRecordRepositoryProvider);
  return DeleteProductionRecordUseCase(repository);
});

final productionRecordControllerProvider =
    StateNotifierProvider<ProductionRecordController, ProductionRecordState>((ref) {
  final getProductionRecordsUseCase = ref.watch(getProductionRecordsUseCaseProvider);
  final createProductionRecordUseCase = ref.watch(createProductionRecordUseCaseProvider);
  final updateProductionRecordUseCase = ref.watch(updateProductionRecordUseCaseProvider);
  final deleteProductionRecordUseCase = ref.watch(deleteProductionRecordUseCaseProvider);
  final authState = ref.watch(authControllerProvider);
  final userId = authState.user?.id ?? '';
  final farmId = authState.user?.farmId ?? authState.user?.id ?? '';

  return ProductionRecordController(
    getProductionRecordsUseCase: getProductionRecordsUseCase,
    createProductionRecordUseCase: createProductionRecordUseCase,
    updateProductionRecordUseCase: updateProductionRecordUseCase,
    deleteProductionRecordUseCase: deleteProductionRecordUseCase,
    userId: userId,
    farmId: farmId,
    ref: ref,
  );
});
