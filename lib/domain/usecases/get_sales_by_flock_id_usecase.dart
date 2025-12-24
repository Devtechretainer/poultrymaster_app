import '../entities/sale.dart';
import '../repositories/sale_repository.dart';

class GetSalesByFlockIdUseCase {
  final SaleRepository repository;

  GetSalesByFlockIdUseCase(this.repository);

  Future<List<Sale>> call(int flockId, String userId, String farmId) async {
    return await repository.getSalesByFlockId(flockId, userId, farmId);
  }
}
