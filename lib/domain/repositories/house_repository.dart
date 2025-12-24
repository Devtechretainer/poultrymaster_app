import '../entities/house.dart';

abstract class HouseRepository {
  Future<List<House>> getAllHouses(String userId, String farmId);

  Future<House?> getHouseById(
    int id,
    String userId,
    String farmId,
  );

  Future<House> createHouse(House house);

  Future<void> updateHouse(House house);

  Future<void> deleteHouse(
    int id,
    String userId,
    String farmId,
  );
}
