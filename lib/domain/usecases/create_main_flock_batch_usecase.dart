import '../entities/flock_batch_request.dart';
import '../entities/main_flock_batch.dart';
import '../repositories/main_flock_batch_repository.dart';

class CreateMainFlockBatchUseCase {
  final MainFlockBatchRepository repository;

  CreateMainFlockBatchUseCase(this.repository);

  Future<MainFlockBatch> call(FlockBatchRequest flockBatchRequest) async {
    return await repository.createMainFlockBatch(flockBatchRequest);
  }
}
