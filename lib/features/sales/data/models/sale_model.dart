import '../../domain/entities/sale.dart';

class SaleModel {
  final String id;
  final DateTime date;
  final String saleType;
  final String channel;
  final List<SaleItemModel> items;
  final double totalRevenue;
  final double totalCost;
  final double totalAdminFee;
  final double totalProfit;
  final String notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  const SaleModel({
    required this.id,
    required this.date,
    required this.saleType,
    required this.channel,
    required this.items,
    required this.totalRevenue,
    required this.totalCost,
    required this.totalAdminFee,
    required this.totalProfit,
    required this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SaleModel.fromJson(Map<String, dynamic> json) {
    return SaleModel(
      id: json['id'] as String,
      date: DateTime.parse(json['date'] as String),
      saleType: json['sale_type'] as String,
      channel: json['channel'] as String,
      items: (json['items'] as List<dynamic>)
          .map((e) => SaleItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalRevenue: (json['total_revenue'] as num).toDouble(),
      totalCost: (json['total_cost'] as num).toDouble(),
      totalAdminFee: (json['total_admin_fee'] as num).toDouble(),
      totalProfit: (json['total_profit'] as num).toDouble(),
      notes: json['notes'] as String? ?? '',
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'sale_type': saleType,
      'channel': channel,
      'items': items.map((e) => e.toJson()).toList(),
      'total_revenue': totalRevenue,
      'total_cost': totalCost,
      'total_admin_fee': totalAdminFee,
      'total_profit': totalProfit,
      'notes': notes,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  // Convert to domain entity
  Sale toDomain() => Sale(
    id: id,
    date: date,
    saleType: saleType,
    channel: channel,
    items: items
        .map(
          (e) => SaleItem(
            productId: e.productId,
            productName: e.productName,
            sku: e.sku,
            quantity: e.quantity,
            sellingPrice: e.sellingPrice,
            costPrice: e.costPrice,
            subtotal: e.subtotal,
            profit: e.profit,
          ),
        )
        .toList(),
    totalRevenue: totalRevenue,
    totalCost: totalCost,
    totalAdminFee: totalAdminFee,
    totalProfit: totalProfit,
    notes: notes,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );
}

class SaleItemModel {
  final String productId;
  final String productName;
  final String sku;
  final int quantity;
  final double sellingPrice;
  final double costPrice;
  final double subtotal;
  final double profit;

  const SaleItemModel({
    required this.productId,
    required this.productName,
    required this.sku,
    required this.quantity,
    required this.sellingPrice,
    required this.costPrice,
    required this.subtotal,
    required this.profit,
  });

  factory SaleItemModel.fromJson(Map<String, dynamic> json) {
    return SaleItemModel(
      productId: json['product_id'] as String,
      productName: json['product_name'] as String,
      sku: json['sku'] as String,
      quantity: json['quantity'] as int,
      sellingPrice: (json['selling_price'] as num).toDouble(),
      costPrice: (json['cost_price'] as num).toDouble(),
      subtotal: (json['subtotal'] as num).toDouble(),
      profit: (json['profit'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'product_name': productName,
      'sku': sku,
      'quantity': quantity,
      'selling_price': sellingPrice,
      'cost_price': costPrice,
      'subtotal': subtotal,
      'profit': profit,
    };
  }

  // Convert to domain entity
  SaleItem toDomain() => SaleItem(
    productId: productId,
    productName: productName,
    sku: sku,
    quantity: quantity,
    sellingPrice: sellingPrice,
    costPrice: costPrice,
    subtotal: subtotal,
    profit: profit,
  );
}

class SaleSummaryModel {
  final int totalSales;
  final double totalRevenue;
  final double totalCost;
  final double totalProfit;
  final double totalAdminFee;
  final List<SaleModel> sales;

  const SaleSummaryModel({
    required this.totalSales,
    required this.totalRevenue,
    required this.totalCost,
    required this.totalProfit,
    required this.totalAdminFee,
    required this.sales,
  });

  factory SaleSummaryModel.fromJson(Map<String, dynamic> json) {
    return SaleSummaryModel(
      totalSales: json['total_sales'] as int,
      totalRevenue: (json['total_revenue'] as num).toDouble(),
      totalCost: (json['total_cost'] as num).toDouble(),
      totalProfit: (json['total_profit'] as num).toDouble(),
      totalAdminFee: (json['total_admin_fee'] as num).toDouble(),
      sales: (json['sales'] as List<dynamic>)
          .map((e) => SaleModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_sales': totalSales,
      'total_revenue': totalRevenue,
      'total_cost': totalCost,
      'total_profit': totalProfit,
      'total_admin_fee': totalAdminFee,
      'sales': sales.map((e) => e.toJson()).toList(),
    };
  }

  // Convert to domain entity
  SaleSummary toDomain() => SaleSummary(
    totalSales: totalSales,
    totalRevenue: totalRevenue,
    totalCost: totalCost,
    totalProfit: totalProfit,
    totalAdminFee: totalAdminFee,
    sales: sales.map((e) => e.toDomain()).toList(),
  );
}
