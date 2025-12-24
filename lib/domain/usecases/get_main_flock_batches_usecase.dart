import '../entities/main_flock_batch.dart';
import '../repositories/main_flock_batch_repository.dart';

class GetMainFlockBatchesUseCase {
  final MainFlockBatchRepository repository;

  GetMainFlockBatchesUseCase(this.repository);

  Future<List<MainFlockBatch>> call(String userId, String farmId) async {
    return await repository.getAllMainFlockBatches(userId, farmId);
  }
}
