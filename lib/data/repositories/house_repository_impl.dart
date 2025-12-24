import '../../domain/entities/house.dart';
import '../../domain/repositories/house_repository.dart';
import '../datasources/house_datasource.dart';
import '../models/house_model.dart';

class HouseRepositoryImpl implements HouseRepository {
  final HouseDataSource dataSource;
  final String? authToken;

  HouseRepositoryImpl({required this.dataSource, this.authToken});

  @override
  Future<List<House>> getAllHouses(String userId, String farmId) async {
    try {
      final houses = await dataSource.getAllHouses(
        userId,
        farmId,
        authToken,
      );
      return houses.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Failed to get houses: $e');
    }
  }

  @override
  Future<House?> getHouseById(
    int id,
    String userId,
    String farmId,
  ) async {
    try {
      final house = await dataSource.getHouseById(
        id,
        userId,
        farmId,
        authToken,
      );
      return house?.toEntity();
    } catch (e) {
      throw Exception('Failed to get house: $e');
    }
  }

  @override
  Future<House> createHouse(House house) async {
    try {
      final model = HouseModel.fromEntity(house);
      final created = await dataSource.createHouse(model, authToken);
      return created.toEntity();
    } catch (e) {
      throw Exception('Failed to create house: $e');
    }
  }

  @override
  Future<void> updateHouse(House house) async {
    try {
      final model = HouseModel.fromEntity(house);
      await dataSource.updateHouse(house.houseId, model, authToken);
    } catch (e) {
      throw Exception('Failed to update house: $e');
    }
  }

  @override
  Future<void> deleteHouse(
    int id,
    String userId,
    String farmId,
  ) async {
    try {
      await dataSource.deleteHouse(id, userId, farmId, authToken);
    } catch (e) {
      throw Exception('Failed to delete house: $e');
    }
  }
}
