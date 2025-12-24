import '../repositories/egg_production_repository.dart';

class DeleteEggProductionUseCase {
  final EggProductionRepository repository;

  DeleteEggProductionUseCase(this.repository);

  Future<void> call(int id, String userId, String farmId) async {
    return await repository.deleteEggProduction(id, userId, farmId);
  }
}
