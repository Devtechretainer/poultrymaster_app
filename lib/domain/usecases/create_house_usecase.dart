import '../entities/house.dart';
import '../repositories/house_repository.dart';

class CreateHouseUseCase {
  final HouseRepository repository;

  CreateHouseUseCase(this.repository);

  Future<House> call(House house) async {
    return await repository.createHouse(house);
  }
}
