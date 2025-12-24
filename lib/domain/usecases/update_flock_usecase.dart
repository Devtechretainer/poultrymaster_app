import '../entities/flock_request.dart';
import '../repositories/flock_repository.dart';

class UpdateFlockUseCase {
  final FlockRepository repository;

  UpdateFlockUseCase(this.repository);

  Future<void> call(int flockId, FlockRequest flockRequest) async {
    return await repository.updateFlock(flockId, flockRequest);
  }
}
