import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/providers/auth_providers.dart';
import '../../application/providers/dashboard_providers.dart';
import '../../data/datasources/expense_datasource.dart';
import '../../data/repositories/expense_repository_impl.dart';
import '../../domain/repositories/expense_repository.dart';
import '../../domain/usecases/create_expense_usecase.dart';
import '../../domain/usecases/delete_expense_usecase.dart';
import '../../domain/usecases/get_expenses_by_flock_id_usecase.dart';
import '../../domain/usecases/get_expenses_usecase.dart';
import '../../domain/usecases/update_expense_usecase.dart';
import '../controllers/expense_controller.dart';
import '../states/expense_state.dart';

final expenseDataSourceProvider = Provider<ExpenseDataSource>((ref) {
  final dio = ref.watch(dioProvider);
  final baseUrl = ref.watch(baseUrlProvider);
  return ExpenseDataSource(dio: dio, baseUrl: baseUrl);
});

final expenseRepositoryProvider = Provider<ExpenseRepository>((ref) {
  final dataSource = ref.watch(expenseDataSourceProvider);
  final authState = ref.watch(authControllerProvider);

  return ExpenseRepositoryImpl(
    dataSource: dataSource,
    authToken: authState.user?.token,
  );
});

final getExpensesUseCaseProvider = Provider<GetExpensesUseCase>((ref) {
  final repository = ref.watch(expenseRepositoryProvider);
  return GetExpensesUseCase(repository);
});

final getExpensesByFlockIdUseCaseProvider = Provider<GetExpensesByFlockIdUseCase>((ref) {
  final repository = ref.watch(expenseRepositoryProvider);
  return GetExpensesByFlockIdUseCase(repository);
});

final createExpenseUseCaseProvider = Provider<CreateExpenseUseCase>((ref) {
  final repository = ref.watch(expenseRepositoryProvider);
  return CreateExpenseUseCase(repository);
});

final updateExpenseUseCaseProvider = Provider<UpdateExpenseUseCase>((ref) {
  final repository = ref.watch(expenseRepositoryProvider);
  return UpdateExpenseUseCase(repository);
});

final deleteExpenseUseCaseProvider = Provider<DeleteExpenseUseCase>((ref) {
  final repository = ref.watch(expenseRepositoryProvider);
  return DeleteExpenseUseCase(repository);
});

final expenseControllerProvider =
    StateNotifierProvider<ExpenseController, ExpenseState>((ref) {
  final getExpensesUseCase = ref.watch(getExpensesUseCaseProvider);
  final getExpensesByFlockIdUseCase = ref.watch(getExpensesByFlockIdUseCaseProvider);
  final createExpenseUseCase = ref.watch(createExpenseUseCaseProvider);
  final updateExpenseUseCase = ref.watch(updateExpenseUseCaseProvider);
  final deleteExpenseUseCase = ref.watch(deleteExpenseUseCaseProvider);
  final authState = ref.watch(authControllerProvider);
  final userId = authState.user?.id ?? '';
  final farmId = authState.user?.farmId ?? authState.user?.id ?? '';

  return ExpenseController(
    getExpensesUseCase: getExpensesUseCase,
    getExpensesByFlockIdUseCase: getExpensesByFlockIdUseCase,
    createExpenseUseCase: createExpenseUseCase,
    updateExpenseUseCase: updateExpenseUseCase,
    deleteExpenseUseCase: deleteExpenseUseCase,
    userId: userId,
    farmId: farmId,
    ref: ref,
  );
});
