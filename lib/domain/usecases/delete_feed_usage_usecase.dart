import '../repositories/feed_usage_repository.dart';

class DeleteFeedUsageUseCase {
  final FeedUsageRepository repository;

  DeleteFeedUsageUseCase(this.repository);

  Future<void> call(int id, String userId, String farmId) async {
    return await repository.deleteFeedUsage(id, userId, farmId);
  }
}
