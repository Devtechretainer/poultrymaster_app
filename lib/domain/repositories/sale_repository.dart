import '../entities/sale.dart';

abstract class SaleRepository {
  Future<List<Sale>> getAllSales(String userId, String farmId);

  Future<Sale?> getSaleById(
    int id,
    String userId,
    String farmId,
  );

  Future<List<Sale>> getSalesByFlockId(
    int flockId,
    String userId,
    String farmId,
  );

  Future<Sale> createSale(Sale sale);

  Future<void> updateSale(Sale sale);

  Future<void> deleteSale(
    int id,
    String userId,
    String farmId,
  );
}
