import '../entities/house.dart';
import '../repositories/house_repository.dart';

class GetHousesUseCase {
  final HouseRepository repository;

  GetHousesUseCase(this.repository);

  Future<List<House>> call(String userId, String farmId) async {
    return await repository.getAllHouses(userId, farmId);
  }
}
