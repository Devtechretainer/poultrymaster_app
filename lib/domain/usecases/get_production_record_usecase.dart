import '../entities/production_record.dart';
import '../repositories/production_record_repository.dart';

class GetProductionRecordUseCase {
  final ProductionRecordRepository repository;

  GetProductionRecordUseCase(this.repository);

  Future<ProductionRecord?> call(int id, String userId, String farmId) async {
    return await repository.getProductionRecordById(id, userId, farmId);
  }
}
