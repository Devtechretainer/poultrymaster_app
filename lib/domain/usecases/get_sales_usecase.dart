import '../entities/sale.dart';
import '../repositories/sale_repository.dart';

class GetSalesUseCase {
  final SaleRepository repository;

  GetSalesUseCase(this.repository);

  Future<List<Sale>> call(String userId, String farmId) async {
    return await repository.getAllSales(userId, farmId);
  }
}
