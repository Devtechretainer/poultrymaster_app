import '../entities/house.dart';
import '../repositories/house_repository.dart';

class UpdateHouseUseCase {
  final HouseRepository repository;

  UpdateHouseUseCase(this.repository);

  Future<void> call(House house) async {
    return await repository.updateHouse(house);
  }
}
