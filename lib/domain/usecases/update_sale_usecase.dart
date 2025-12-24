import '../entities/sale.dart';
import '../repositories/sale_repository.dart';

class UpdateSaleUseCase {
  final SaleRepository repository;

  UpdateSaleUseCase(this.repository);

  Future<void> call(Sale sale) async {
    return await repository.updateSale(sale);
  }
}
