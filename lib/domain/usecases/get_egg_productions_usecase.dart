import '../entities/egg_production.dart';
import '../repositories/egg_production_repository.dart';

class GetEggProductionsUseCase {
  final EggProductionRepository repository;

  GetEggProductionsUseCase(this.repository);

  Future<List<EggProduction>> call(String userId, String farmId) async {
    return await repository.getAllEggProductions(userId, farmId);
  }
}
