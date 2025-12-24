import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/feed_usage.dart';
import '../../domain/usecases/create_feed_usage_usecase.dart';
import '../../domain/usecases/delete_feed_usage_usecase.dart';
import '../../domain/usecases/get_feed_usages_usecase.dart';
import '../../domain/usecases/update_feed_usage_usecase.dart';
import '../providers/dashboard_providers.dart';
import '../states/feed_usage_state.dart';

class FeedUsageController extends StateNotifier<FeedUsageState> {
  final GetFeedUsagesUseCase getFeedUsagesUseCase;
  final CreateFeedUsageUseCase createFeedUsageUseCase;
  final UpdateFeedUsageUseCase updateFeedUsageUseCase;
  final DeleteFeedUsageUseCase deleteFeedUsageUseCase;
  final String userId;
  final String farmId;
  final Ref ref;

  FeedUsageController({
    required this.getFeedUsagesUseCase,
    required this.createFeedUsageUseCase,
    required this.updateFeedUsageUseCase,
    required this.deleteFeedUsageUseCase,
    required this.userId,
    required this.farmId,
    required this.ref,
  }) : super(const FeedUsageState()) {
    loadFeedUsages();
  }

  Future<void> loadFeedUsages() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final usages = await getFeedUsagesUseCase(userId, farmId);
      state = state.copyWith(feedUsages: usages, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }

  Future<bool> createFeedUsage(FeedUsage feedUsage) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await createFeedUsageUseCase(feedUsage);
      await loadFeedUsages();
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

  Future<bool> updateFeedUsage(FeedUsage feedUsage) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await updateFeedUsageUseCase(feedUsage);
      await loadFeedUsages();
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

  Future<bool> deleteFeedUsage(int id) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await deleteFeedUsageUseCase(id, userId, farmId);
      await loadFeedUsages();
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
