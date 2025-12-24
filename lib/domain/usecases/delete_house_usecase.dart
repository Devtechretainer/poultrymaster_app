import '../repositories/house_repository.dart';

class DeleteHouseUseCase {
  final HouseRepository repository;

  DeleteHouseUseCase(this.repository);

  Future<void> call(int id, String userId, String farmId) async {
    return await repository.deleteHouse(id, userId, farmId);
  }
}
