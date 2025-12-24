import '../entities/production_record.dart';
import '../repositories/production_record_repository.dart';

class GetProductionRecordsUseCase {
  final ProductionRecordRepository repository;

  GetProductionRecordsUseCase(this.repository);

  Future<List<ProductionRecord>> call(String userId, String farmId) async {
    return await repository.getAllProductionRecords(userId, farmId);
  }
}
