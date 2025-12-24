import '../entities/flock_batch_request.dart';
import '../repositories/main_flock_batch_repository.dart';

class UpdateMainFlockBatchUseCase {
  final MainFlockBatchRepository repository;

  UpdateMainFlockBatchUseCase(this.repository);

  Future<void> call(int batchId, FlockBatchRequest flockBatchRequest) async {
    return await repository.updateMainFlockBatch(batchId, flockBatchRequest);
  }
}
