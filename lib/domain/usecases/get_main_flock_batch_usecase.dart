import '../entities/main_flock_batch.dart';
import '../repositories/main_flock_batch_repository.dart';

class GetMainFlockBatchUseCase {
  final MainFlockBatchRepository repository;

  GetMainFlockBatchUseCase(this.repository);

  Future<MainFlockBatch?> call(int batchId, String userId, String farmId) async {
    return await repository.getMainFlockBatchById(batchId, userId, farmId);
  }
}
