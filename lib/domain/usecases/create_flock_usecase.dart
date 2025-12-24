import '../entities/flock_request.dart';
import '../repositories/flock_repository.dart';

import '../entities/flock.dart';

class CreateFlockUseCase {
  final FlockRepository repository;

  CreateFlockUseCase(this.repository);

  Future<Flock> call(FlockRequest flockRequest) async {
    return await repository.createFlock(flockRequest);
  }
}
