import '../repositories/main_flock_batch_repository.dart';

class DeleteMainFlockBatchUseCase {
  final MainFlockBatchRepository repository;

  DeleteMainFlockBatchUseCase(this.repository);

  Future<void> call(int batchId, String userId, String farmId) async {
    return await repository.deleteMainFlockBatch(batchId, userId, farmId);
  }
}
