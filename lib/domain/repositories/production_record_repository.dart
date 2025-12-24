import '../entities/production_record.dart';

abstract class ProductionRecordRepository {
  Future<List<ProductionRecord>> getAllProductionRecords(
      String userId, String farmId);

  Future<ProductionRecord?> getProductionRecordById(
    int id,
    String userId,
    String farmId,
  );

  Future<ProductionRecord> createProductionRecord(ProductionRecord productionRecord);

  Future<void> updateProductionRecord(ProductionRecord productionRecord);

  Future<void> deleteProductionRecord(
    int id,
    String userId,
    String farmId,
  );
}
