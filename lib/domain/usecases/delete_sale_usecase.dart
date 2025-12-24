import '../repositories/sale_repository.dart';

class DeleteSaleUseCase {
  final SaleRepository repository;

  DeleteSaleUseCase(this.repository);

  Future<void> call(int id, String userId, String farmId) async {
    return await repository.deleteSale(id, userId, farmId);
  }
}
