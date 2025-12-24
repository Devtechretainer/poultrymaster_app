import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/providers/auth_providers.dart';
import '../../application/providers/dashboard_providers.dart';
import '../../data/datasources/sale_datasource.dart';
import '../../data/repositories/sale_repository_impl.dart';
import '../../domain/repositories/sale_repository.dart';
import '../../domain/usecases/create_sale_usecase.dart';
import '../../domain/usecases/delete_sale_usecase.dart';
import '../../domain/usecases/get_sales_by_flock_id_usecase.dart';
import '../../domain/usecases/get_sales_usecase.dart';
import '../../domain/usecases/update_sale_usecase.dart';
import '../controllers/sale_controller.dart';
import '../states/sale_state.dart';

final saleDataSourceProvider = Provider<SaleDataSource>((ref) {
  final dio = ref.watch(dioProvider);
  final baseUrl = ref.watch(baseUrlProvider);
  return SaleDataSource(dio: dio, baseUrl: baseUrl);
});

final saleRepositoryProvider = Provider<SaleRepository>((ref) {
  final dataSource = ref.watch(saleDataSourceProvider);
  final authState = ref.watch(authControllerProvider);

  return SaleRepositoryImpl(
    dataSource: dataSource,
    authToken: authState.user?.token,
  );
});

final getSalesUseCaseProvider = Provider<GetSalesUseCase>((ref) {
  final repository = ref.watch(saleRepositoryProvider);
  return GetSalesUseCase(repository);
});

final getSalesByFlockIdUseCaseProvider = Provider<GetSalesByFlockIdUseCase>((ref) {
  final repository = ref.watch(saleRepositoryProvider);
  return GetSalesByFlockIdUseCase(repository);
});

final createSaleUseCaseProvider = Provider<CreateSaleUseCase>((ref) {
  final repository = ref.watch(saleRepositoryProvider);
  return CreateSaleUseCase(repository);
});

final updateSaleUseCaseProvider = Provider<UpdateSaleUseCase>((ref) {
  final repository = ref.watch(saleRepositoryProvider);
  return UpdateSaleUseCase(repository);
});

final deleteSaleUseCaseProvider = Provider<DeleteSaleUseCase>((ref) {
  final repository = ref.watch(saleRepositoryProvider);
  return DeleteSaleUseCase(repository);
});

final saleControllerProvider = StateNotifierProvider<SaleController, SaleState>((ref) {
  final getSalesUseCase = ref.watch(getSalesUseCaseProvider);
  final getSalesByFlockIdUseCase = ref.watch(getSalesByFlockIdUseCaseProvider);
  final createSaleUseCase = ref.watch(createSaleUseCaseProvider);
  final updateSaleUseCase = ref.watch(updateSaleUseCaseProvider);
  final deleteSaleUseCase = ref.watch(deleteSaleUseCaseProvider);
  final authState = ref.watch(authControllerProvider);
  final userId = authState.user?.id ?? '';
  final farmId = authState.user?.farmId ?? authState.user?.id ?? '';

  return SaleController(
    getSalesUseCase: getSalesUseCase,
    getSalesByFlockIdUseCase: getSalesByFlockIdUseCase,
    createSaleUseCase: createSaleUseCase,
    updateSaleUseCase: updateSaleUseCase,
    deleteSaleUseCase: deleteSaleUseCase,
    userId: userId,
    farmId: farmId,
    ref: ref,
  );
});
