import '../entities/flock.dart';
import '../repositories/flock_repository.dart';

class GetFlocksUseCase {
  final FlockRepository repository;

  GetFlocksUseCase(this.repository);

  Future<List<Flock>> call(String userId, String farmId) async {
    return await repository.getAllFlocks(userId, farmId);
  }
}
