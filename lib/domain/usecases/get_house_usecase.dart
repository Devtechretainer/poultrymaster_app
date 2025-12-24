import '../entities/house.dart';
import '../repositories/house_repository.dart';

class GetHouseUseCase {
  final HouseRepository repository;

  GetHouseUseCase(this.repository);

  Future<House?> call(int id, String userId, String farmId) async {
    return await repository.getHouseById(id, userId, farmId);
  }
}
