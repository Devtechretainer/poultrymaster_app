import '../repositories/production_record_repository.dart';

class DeleteProductionRecordUseCase {
  final ProductionRecordRepository repository;

  DeleteProductionRecordUseCase(this.repository);

  Future<void> call(int id, String userId, String farmId) async {
    return await repository.deleteProductionRecord(id, userId, farmId);
  }
}
