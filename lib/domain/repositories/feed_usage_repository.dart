import '../entities/feed_usage.dart';

abstract class FeedUsageRepository {
  Future<List<FeedUsage>> getAllFeedUsages(String userId, String farmId);

  Future<FeedUsage?> getFeedUsageById(
    int id,
    String userId,
    String farmId,
  );

  Future<FeedUsage> createFeedUsage(FeedUsage feedUsage);

  Future<void> updateFeedUsage(FeedUsage feedUsage);

  Future<void> deleteFeedUsage(
    int id,
    String userId,
    String farmId,
  );
}
