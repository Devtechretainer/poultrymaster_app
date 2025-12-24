import '../entities/main_flock_batch.dart';
import '../entities/flock_batch_request.dart';

abstract class MainFlockBatchRepository {
  Future<List<MainFlockBatch>> getAllMainFlockBatches(
      String userId, String farmId);

  Future<MainFlockBatch?> getMainFlockBatchById(
    int batchId,
    String userId,
    String farmId,
  );

  Future<MainFlockBatch> createMainFlockBatch(FlockBatchRequest flockBatchRequest);

  Future<void> updateMainFlockBatch(int batchId, FlockBatchRequest flockBatchRequest);

  Future<void> deleteMainFlockBatch(
    int batchId,
    String userId,
    String farmId,
  );
}
