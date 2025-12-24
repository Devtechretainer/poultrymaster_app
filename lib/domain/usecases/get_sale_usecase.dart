import '../entities/sale.dart';
import '../repositories/sale_repository.dart';

class GetSaleUseCase {
  final SaleRepository repository;

  GetSaleUseCase(this.repository);

  Future<Sale?> call(int id, String userId, String farmId) async {
    return await repository.getSaleById(id, userId, farmId);
  }
}
