import '../entities/sale.dart';

abstract class SalesRepository {
  Future<Sale> recordSale({
    required String saleType,
    required String channel,
    required List<SaleItem> items,
    required double adminFee,
    required String notes,
  });

  Future<List<Sale>> getSalesByDate(DateTime date);
  Future<SaleSummary> getSalesSummary(DateTime startDate, DateTime endDate);
  Future<Sale> getSaleById(String id);
  Future<void> updateSale(Sale sale);
  Future<void> deleteSale(String id);
}
