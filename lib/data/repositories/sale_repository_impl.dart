import '../../domain/entities/sale.dart';
import '../../domain/repositories/sale_repository.dart';
import '../datasources/sale_datasource.dart';
import '../models/sale_model.dart';

class SaleRepositoryImpl implements SaleRepository {
  final SaleDataSource dataSource;
  final String? authToken;

  SaleRepositoryImpl({required this.dataSource, this.authToken});

  @override
  Future<List<Sale>> getAllSales(String userId, String farmId) async {
    try {
      final sales = await dataSource.getAllSales(
        userId,
        farmId,
        authToken,
      );
      return sales.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Failed to get sales: $e');
    }
  }

  @override
  Future<Sale?> getSaleById(
    int id,
    String userId,
    String farmId,
  ) async {
    try {
      final sale = await dataSource.getSaleById(
        id,
        userId,
        farmId,
        authToken,
      );
      return sale?.toEntity();
    } catch (e) {
      throw Exception('Failed to get sale: $e');
    }
  }

  @override
  Future<List<Sale>> getSalesByFlockId(
      int flockId, String userId, String farmId) async {
    try {
      final sales = await dataSource.getSalesByFlockId(
        flockId,
        userId,
        farmId,
        authToken,
      );
      return sales.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Failed to get sales by flock ID: $e');
    }
  }

  @override
  Future<Sale> createSale(Sale sale) async {
    try {
      final model = SaleModel.fromEntity(sale);
      final created = await dataSource.createSale(model, authToken);
      return created.toEntity();
    } catch (e) {
      throw Exception('Failed to create sale: $e');
    }
  }

  @override
  Future<void> updateSale(Sale sale) async {
    try {
      final model = SaleModel.fromEntity(sale);
      await dataSource.updateSale(sale.saleId, model, authToken);
    } catch (e) {
      throw Exception('Failed to update sale: $e');
    }
  }

  @override
  Future<void> deleteSale(
    int id,
    String userId,
    String farmId,
  ) async {
    try {
      await dataSource.deleteSale(id, userId, farmId, authToken);
    } catch (e) {
      throw Exception('Failed to delete sale: $e');
    }
  }
}
