import '../entities/egg_production.dart';
import '../repositories/egg_production_repository.dart';

class GetEggProductionUseCase {
  final EggProductionRepository repository;

  GetEggProductionUseCase(this.repository);

  Future<EggProduction?> call(int id, String userId, String farmId) async {
    return await repository.getEggProductionById(id, userId, farmId);
  }
}
