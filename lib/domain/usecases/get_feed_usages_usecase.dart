import '../entities/feed_usage.dart';
import '../repositories/feed_usage_repository.dart';

class GetFeedUsagesUseCase {
  final FeedUsageRepository repository;

  GetFeedUsagesUseCase(this.repository);

  Future<List<FeedUsage>> call(String userId, String farmId) async {
    return await repository.getAllFeedUsages(userId, farmId);
  }
}
