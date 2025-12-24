import '../entities/egg_production.dart';
import '../repositories/egg_production_repository.dart';

class UpdateEggProductionUseCase {
  final EggProductionRepository repository;

  UpdateEggProductionUseCase(this.repository);

  Future<void> call(EggProduction eggProduction) async {
    return await repository.updateEggProduction(eggProduction);
  }
}
