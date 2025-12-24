import '../../domain/entities/egg_production.dart';
import '../../domain/repositories/egg_production_repository.dart';
import '../datasources/egg_production_datasource.dart';
import '../models/egg_production_model.dart';

class EggProductionRepositoryImpl implements EggProductionRepository {
  final EggProductionDataSource dataSource;
  final String? authToken;

  EggProductionRepositoryImpl({required this.dataSource, this.authToken});

  @override
  Future<List<EggProduction>> getAllEggProductions(
      String userId, String farmId) async {
    try {
      final productions = await dataSource.getAllEggProductions(
        userId,
        farmId,
        authToken,
      );
      return productions.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Failed to get egg productions: $e');
    }
  }

  @override
  Future<EggProduction?> getEggProductionById(
    int id,
    String userId,
    String farmId,
  ) async {
    try {
      final production = await dataSource.getEggProductionById(
        id,
        userId,
        farmId,
        authToken,
      );
      return production?.toEntity();
    } catch (e) {
      throw Exception('Failed to get egg production: $e');
    }
  }

  @override
  Future<EggProduction> createEggProduction(EggProduction eggProduction) async {
    try {
      final model = EggProductionModel.fromEntity(eggProduction);
      final created = await dataSource.createEggProduction(model, authToken);
      return created.toEntity();
    } catch (e) {
      throw Exception('Failed to create egg production: $e');
    }
  }

  @override
  Future<void> updateEggProduction(EggProduction eggProduction) async {
    try {
      final model = EggProductionModel.fromEntity(eggProduction);
      await dataSource.updateEggProduction(eggProduction.productionId, model, authToken);
    } catch (e) {
      throw Exception('Failed to update egg production: $e');
    }
  }

  @override
  Future<void> deleteEggProduction(
    int id,
    String userId,
    String farmId,
  ) async {
    try {
      await dataSource.deleteEggProduction(id, userId, farmId, authToken);
    } catch (e) {
      throw Exception('Failed to delete egg production: $e');
    }
  }
}
