import '../entities/egg_production.dart';
import '../repositories/egg_production_repository.dart';

class CreateEggProductionUseCase {
  final EggProductionRepository repository;

  CreateEggProductionUseCase(this.repository);

  Future<EggProduction> call(EggProduction eggProduction) async {
    return await repository.createEggProduction(eggProduction);
  }
}
