import '../entities/flock.dart';
import '../entities/flock_request.dart';

abstract class FlockRepository {
  Future<List<Flock>> getAllFlocks(String userId, String farmId);

  Future<Flock?> getFlockById(
    int flockId,
    String userId,
    String farmId,
  );

  Future<Flock> createFlock(FlockRequest flockRequest);

  Future<void> updateFlock(int flockId, FlockRequest flockRequest);

  Future<void> deleteFlock(int flockId, String userId, String farmId);
}
