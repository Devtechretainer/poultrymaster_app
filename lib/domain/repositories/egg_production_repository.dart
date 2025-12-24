import '../entities/egg_production.dart';

abstract class EggProductionRepository {
  Future<List<EggProduction>> getAllEggProductions(String userId, String farmId);

  Future<EggProduction?> getEggProductionById(
    int id,
    String userId,
    String farmId,
  );

  Future<EggProduction> createEggProduction(EggProduction eggProduction);

  Future<void> updateEggProduction(EggProduction eggProduction);

  Future<void> deleteEggProduction(
    int id,
    String userId,
    String farmId,
  );
}
