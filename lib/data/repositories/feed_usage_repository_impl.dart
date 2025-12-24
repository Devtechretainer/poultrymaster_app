import '../../domain/entities/feed_usage.dart';
import '../../domain/repositories/feed_usage_repository.dart';
import '../datasources/feed_usage_datasource.dart';
import '../models/feed_usage_model.dart';

class FeedUsageRepositoryImpl implements FeedUsageRepository {
  final FeedUsageDataSource dataSource;
  final String? authToken;

  FeedUsageRepositoryImpl({required this.dataSource, this.authToken});

  @override
  Future<List<FeedUsage>> getAllFeedUsages(
      String userId, String farmId) async {
    try {
      final usages = await dataSource.getAllFeedUsages(
        userId,
        farmId,
        authToken,
      );
      return usages.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Failed to get feed usages: $e');
    }
  }

  @override
  Future<FeedUsage?> getFeedUsageById(
    int id,
    String userId,
    String farmId,
  ) async {
    try {
      final usage = await dataSource.getFeedUsageById(
        id,
        userId,
        farmId,
        authToken,
      );
      return usage?.toEntity();
    } catch (e) {
      throw Exception('Failed to get feed usage: $e');
    }
  }

  @override
  Future<FeedUsage> createFeedUsage(FeedUsage feedUsage) async {
    try {
      final model = FeedUsageModel.fromEntity(feedUsage);
      final created = await dataSource.createFeedUsage(model, authToken);
      return created.toEntity();
    } catch (e) {
      throw Exception('Failed to create feed usage: $e');
    }
  }

  @override
  Future<void> updateFeedUsage(FeedUsage feedUsage) async {
    try {
      final model = FeedUsageModel.fromEntity(feedUsage);
      await dataSource.updateFeedUsage(
          feedUsage.feedUsageId, model, authToken);
    } catch (e) {
      throw Exception('Failed to update feed usage: $e');
    }
  }

  @override
  Future<void> deleteFeedUsage(
    int id,
    String userId,
    String farmId,
  ) async {
    try {
      await dataSource.deleteFeedUsage(id, userId, farmId, authToken);
    } catch (e) {
      throw Exception('Failed to delete feed usage: $e');
    }
  }
}
