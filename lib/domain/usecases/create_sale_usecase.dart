import '../entities/sale.dart';
import '../repositories/sale_repository.dart';

class CreateSaleUseCase {
  final SaleRepository repository;

  CreateSaleUseCase(this.repository);

  Future<Sale> call(Sale sale) async {
    return await repository.createSale(sale);
  }
}
