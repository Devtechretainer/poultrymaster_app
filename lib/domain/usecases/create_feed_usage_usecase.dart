import '../entities/feed_usage.dart';
import '../repositories/feed_usage_repository.dart';

class CreateFeedUsageUseCase {
  final FeedUsageRepository repository;

  CreateFeedUsageUseCase(this.repository);

  Future<FeedUsage> call(FeedUsage feedUsage) async {
    return await repository.createFeedUsage(feedUsage);
  }
}
