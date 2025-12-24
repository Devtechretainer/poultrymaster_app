import '../entities/feed_usage.dart';
import '../repositories/feed_usage_repository.dart';

class UpdateFeedUsageUseCase {
  final FeedUsageRepository repository;

  UpdateFeedUsageUseCase(this.repository);

  Future<void> call(FeedUsage feedUsage) async {
    return await repository.updateFeedUsage(feedUsage);
  }
}
