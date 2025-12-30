import '../../domain/entities/flock.dart';
import '../../domain/entities/flock_request.dart';
import '../../domain/repositories/flock_repository.dart';
import '../datasources/flock_datasource.dart';

class FlockRepositoryImpl implements FlockRepository {
  final FlockDataSource dataSource;
  final String? authToken;

  FlockRepositoryImpl({required this.dataSource, this.authToken});

  @override
  Future<List<Flock>> getAllFlocks(String userId, String farmId) async {
    try {
      final flocks = await dataSource.getAllFlocks(userId, farmId, authToken);
      return flocks.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Failed to get flocks: $e');
    }
  }

  @override
  Future<Flock?> getFlockById(int flockId, String userId, String farmId) async {
    try {
      final flock = await dataSource.getFlockById(
        flockId,
        userId,
        farmId,
        authToken,
      );
      return flock?.toEntity();
    } catch (e) {
      throw Exception('Failed to get flock: $e');
    }
  }

  @override
  Future<Flock> createFlock(FlockRequest flockRequest) async {
    try {
      final created = await dataSource.createFlock(flockRequest, authToken);
      return created.toEntity();
    } catch (e) {
      throw Exception('Failed to create flock: $e');
    }
  }

  @override
  Future<void> updateFlock(int flockId, FlockRequest flockRequest) async {
    try {
      await dataSource.updateFlock(flockId, flockRequest, authToken);
    } catch (e) {
      throw Exception('Failed to update flock: $e');
    }
  }

  @override
  Future<void> deleteFlock(int flockId, String userId, String farmId) async {
    try {
      await dataSource.deleteFlock(flockId, userId, farmId, authToken);
    } catch (e) {
      throw Exception('Failed to delete flock: $e');
    }
  }
}
