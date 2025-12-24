import '../../domain/entities/main_flock_batch.dart';
import '../../domain/entities/flock_batch_request.dart';
import '../../domain/repositories/main_flock_batch_repository.dart';
import '../datasources/main_flock_batch_datasource.dart';
import '../models/main_flock_batch_model.dart';

class MainFlockBatchRepositoryImpl implements MainFlockBatchRepository {
  final MainFlockBatchDataSource dataSource;
  final String? authToken;

  MainFlockBatchRepositoryImpl({required this.dataSource, this.authToken});

  @override
  Future<List<MainFlockBatch>> getAllMainFlockBatches(
      String userId, String farmId) async {
    try {
      final batches = await dataSource.getAllMainFlockBatches(
        userId,
        farmId,
        authToken,
      );
      return batches.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Failed to get main flock batches: $e');
    }
  }

  @override
  Future<MainFlockBatch?> getMainFlockBatchById(
    int batchId,
    String userId,
    String farmId,
  ) async {
    try {
      final batch = await dataSource.getMainFlockBatchById(
        batchId,
        userId,
        farmId,
        authToken,
      );
      return batch?.toEntity();
    } catch (e) {
      throw Exception('Failed to get main flock batch: $e');
    }
  }

  @override
  Future<MainFlockBatch> createMainFlockBatch(
      FlockBatchRequest flockBatchRequest) async {
    try {
      final created =
          await dataSource.createMainFlockBatch(flockBatchRequest, authToken);
      return created.toEntity();
    } catch (e) {
      throw Exception('Failed to create main flock batch: $e');
    }
  }

  @override
  Future<void> updateMainFlockBatch(
      int batchId, FlockBatchRequest flockBatchRequest) async {
    try {
      await dataSource.updateMainFlockBatch(
          batchId, flockBatchRequest, authToken);
    } catch (e) {
      throw Exception('Failed to update main flock batch: $e');
    }
  }

  @override
  Future<void> deleteMainFlockBatch(
    int batchId,
    String userId,
    String farmId,
  ) async {
    try {
      await dataSource.deleteMainFlockBatch(batchId, userId, farmId, authToken);
    } catch (e) {
      throw Exception('Failed to delete main flock batch: $e');
    }
  }
}
