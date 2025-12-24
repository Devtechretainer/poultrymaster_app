import '../repositories/flock_repository.dart';

class DeleteFlockUseCase {
  final FlockRepository repository;

  DeleteFlockUseCase(this.repository);

  Future<void> call(int flockId, String userId, String farmId) async {
    return await repository.deleteFlock(flockId, userId, farmId);
  }
}
