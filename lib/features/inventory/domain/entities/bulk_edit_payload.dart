import 'package:equatable/equatable.dart';

/// Payload for mass-updating variants (price and stock in one operation).
class BulkEditPayload extends Equatable {
  final List<String> variantIds;
  final double? newSellingPrice;
  final bool incrementStock;
  final int? stockQuantity;
  final int? minStockLevel;

  const BulkEditPayload({
    required this.variantIds,
    this.newSellingPrice,
    this.incrementStock = false,
    this.stockQuantity,
    this.minStockLevel,
  });

  Map<String, dynamic> toJson() {
    return {
      'variantIds': variantIds,
      'newSellingPrice': newSellingPrice,
      'incrementStock': incrementStock,
      'stockQuantity': stockQuantity,
      'minStockLevel': minStockLevel,
    };
  }

  @override
  List<Object?> get props => [
    variantIds,
    newSellingPrice,
    incrementStock,
    stockQuantity,
    minStockLevel,
  ];
}
