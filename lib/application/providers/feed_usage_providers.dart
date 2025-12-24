import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/providers/auth_providers.dart';
import '../../application/providers/dashboard_providers.dart';
import '../../data/datasources/feed_usage_datasource.dart';
import '../../data/repositories/feed_usage_repository_impl.dart';
import '../../domain/repositories/feed_usage_repository.dart';
import '../../domain/usecases/create_feed_usage_usecase.dart';
import '../../domain/usecases/delete_feed_usage_usecase.dart';
import '../../domain/usecases/get_feed_usages_usecase.dart';
import '../../domain/usecases/get_feed_usage_usecase.dart';
import '../../domain/usecases/update_feed_usage_usecase.dart';
import '../controllers/feed_usage_controller.dart';
import '../states/feed_usage_state.dart';

final feedUsageDataSourceProvider = Provider<FeedUsageDataSource>((ref) {
  final dio = ref.watch(dioProvider);
  final baseUrl = ref.watch(baseUrlProvider);
  return FeedUsageDataSource(dio: dio, baseUrl: baseUrl);
});

final feedUsageRepositoryProvider = Provider<FeedUsageRepository>((ref) {
  final dataSource = ref.watch(feedUsageDataSourceProvider);
  final authState = ref.watch(authControllerProvider);

  return FeedUsageRepositoryImpl(
    dataSource: dataSource,
    authToken: authState.user?.token,
  );
});

final getFeedUsagesUseCaseProvider = Provider<GetFeedUsagesUseCase>((ref) {
  final repository = ref.watch(feedUsageRepositoryProvider);
  return GetFeedUsagesUseCase(repository);
});

final getFeedUsageUseCaseProvider = Provider<GetFeedUsageUseCase>((ref) {
  final repository = ref.watch(feedUsageRepositoryProvider);
  return GetFeedUsageUseCase(repository);
});

final createFeedUsageUseCaseProvider = Provider<CreateFeedUsageUseCase>((ref) {
  final repository = ref.watch(feedUsageRepositoryProvider);
  return CreateFeedUsageUseCase(repository);
});

final updateFeedUsageUseCaseProvider = Provider<UpdateFeedUsageUseCase>((ref) {
  final repository = ref.watch(feedUsageRepositoryProvider);
  return UpdateFeedUsageUseCase(repository);
});

final deleteFeedUsageUseCaseProvider = Provider<DeleteFeedUsageUseCase>((ref) {
  final repository = ref.watch(feedUsageRepositoryProvider);
  return DeleteFeedUsageUseCase(repository);
});

final feedUsageControllerProvider =
    StateNotifierProvider<FeedUsageController, FeedUsageState>((ref) {
  final getFeedUsagesUseCase = ref.watch(getFeedUsagesUseCaseProvider);
  final createFeedUsageUseCase = ref.watch(createFeedUsageUseCaseProvider);
  final updateFeedUsageUseCase = ref.watch(updateFeedUsageUseCaseProvider);
  final deleteFeedUsageUseCase = ref.watch(deleteFeedUsageUseCaseProvider);
  final authState = ref.watch(authControllerProvider);
  final userId = authState.user?.id ?? '';
  final farmId = authState.user?.farmId ?? authState.user?.id ?? '';

  return FeedUsageController(
    getFeedUsagesUseCase: getFeedUsagesUseCase,
    createFeedUsageUseCase: createFeedUsageUseCase,
    updateFeedUsageUseCase: updateFeedUsageUseCase,
    deleteFeedUsageUseCase: deleteFeedUsageUseCase,
    userId: userId,
    farmId: farmId,
    ref: ref,
  );
});
