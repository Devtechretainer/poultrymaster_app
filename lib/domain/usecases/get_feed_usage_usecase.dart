import '../entities/feed_usage.dart';
import '../repositories/feed_usage_repository.dart';

class GetFeedUsageUseCase {
  final FeedUsageRepository repository;

  GetFeedUsageUseCase(this.repository);

  Future<FeedUsage?> call(int id, String userId, String farmId) async {
    return await repository.getFeedUsageById(id, userId, farmId);
  }
}
