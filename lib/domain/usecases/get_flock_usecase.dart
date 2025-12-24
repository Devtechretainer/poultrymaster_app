import '../entities/flock.dart';
import '../repositories/flock_repository.dart';

class GetFlockUseCase {
  final FlockRepository repository;

  GetFlockUseCase(this.repository);

  Future<Flock?> call(int flockId, String userId, String farmId) async {
    return await repository.getFlockById(flockId, userId, farmId);
  }
}
