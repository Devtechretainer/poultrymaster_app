import '../../domain/entities/production_record.dart';
import '../../domain/repositories/production_record_repository.dart';
import '../datasources/production_record_datasource.dart';
import '../models/production_record_model.dart';

class ProductionRecordRepositoryImpl implements ProductionRecordRepository {
  final ProductionRecordDataSource dataSource;
  final String? authToken;

  ProductionRecordRepositoryImpl({required this.dataSource, this.authToken});

  @override
  Future<List<ProductionRecord>> getAllProductionRecords(
      String userId, String farmId) async {
    try {
      final records = await dataSource.getAllProductionRecords(
        userId,
        farmId,
        authToken,
      );
      return records.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Failed to get production records: $e');
    }
  }

  @override
  Future<ProductionRecord?> getProductionRecordById(
    int id,
    String userId,
    String farmId,
  ) async {
    try {
      final record = await dataSource.getProductionRecordById(
        id,
        userId,
        farmId,
        authToken,
      );
      return record?.toEntity();
    } catch (e) {
      throw Exception('Failed to get production record: $e');
    }
  }

  @override
  Future<ProductionRecord> createProductionRecord(
      ProductionRecord productionRecord) async {
    try {
      final model = ProductionRecordModel.fromEntity(productionRecord);
      final created =
          await dataSource.createProductionRecord(model, authToken);
      return created.toEntity();
    } catch (e) {
      throw Exception('Failed to create production record: $e');
    }
  }

  @override
  Future<void> updateProductionRecord(ProductionRecord productionRecord) async {
    try {
      final model = ProductionRecordModel.fromEntity(productionRecord);
      await dataSource.updateProductionRecord(
          productionRecord.id, model, authToken);
    } catch (e) {
      throw Exception('Failed to update production record: $e');
    }
  }

  @override
  Future<void> deleteProductionRecord(
    int id,
    String userId,
    String farmId,
  ) async {
    try {
      await dataSource.deleteProductionRecord(id, userId, farmId, authToken);
    } catch (e) {
      throw Exception('Failed to delete production record: $e');
    }
  }
}
