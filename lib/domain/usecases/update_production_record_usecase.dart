import '../entities/production_record.dart';
import '../repositories/production_record_repository.dart';

class UpdateProductionRecordUseCase {
  final ProductionRecordRepository repository;

  UpdateProductionRecordUseCase(this.repository);

  Future<void> call(ProductionRecord productionRecord) async {
    return await repository.updateProductionRecord(productionRecord);
  }
}
