import '../entities/production_record.dart';
import '../repositories/production_record_repository.dart';

class CreateProductionRecordUseCase {
  final ProductionRecordRepository repository;

  CreateProductionRecordUseCase(this.repository);

  Future<ProductionRecord> call(ProductionRecord productionRecord) async {
    return await repository.createProductionRecord(productionRecord);
  }
}
