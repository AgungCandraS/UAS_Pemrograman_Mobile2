// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sales_report.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SalesReportImpl _$$SalesReportImplFromJson(Map<String, dynamic> json) =>
    _$SalesReportImpl(
      id: json['id'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      totalTransactions: (json['totalTransactions'] as num).toInt(),
      totalRevenue: (json['totalRevenue'] as num).toDouble(),
      totalCost: (json['totalCost'] as num).toDouble(),
      totalAdminFee: (json['totalAdminFee'] as num).toDouble(),
      totalProfit: (json['totalProfit'] as num).toDouble(),
      productSummaries: (json['productSummaries'] as List<dynamic>)
          .map((e) => ProductSalesSummary.fromJson(e as Map<String, dynamic>))
          .toList(),
      dailyStats: (json['dailyStats'] as List<dynamic>)
          .map((e) => DailySalesStats.fromJson(e as Map<String, dynamic>))
          .toList(),
      generatedAt: DateTime.parse(json['generatedAt'] as String),
    );

Map<String, dynamic> _$$SalesReportImplToJson(_$SalesReportImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate.toIso8601String(),
      'totalTransactions': instance.totalTransactions,
      'totalRevenue': instance.totalRevenue,
      'totalCost': instance.totalCost,
      'totalAdminFee': instance.totalAdminFee,
      'totalProfit': instance.totalProfit,
      'productSummaries': instance.productSummaries,
      'dailyStats': instance.dailyStats,
      'generatedAt': instance.generatedAt.toIso8601String(),
    };

_$ProductSalesSummaryImpl _$$ProductSalesSummaryImplFromJson(
        Map<String, dynamic> json) =>
    _$ProductSalesSummaryImpl(
      productName: json['productName'] as String,
      totalQuantity: (json['totalQuantity'] as num).toInt(),
      totalRevenue: (json['totalRevenue'] as num).toDouble(),
      totalCost: (json['totalCost'] as num).toDouble(),
      totalProfit: (json['totalProfit'] as num).toDouble(),
      averagePrice: (json['averagePrice'] as num).toDouble(),
    );

Map<String, dynamic> _$$ProductSalesSummaryImplToJson(
        _$ProductSalesSummaryImpl instance) =>
    <String, dynamic>{
      'productName': instance.productName,
      'totalQuantity': instance.totalQuantity,
      'totalRevenue': instance.totalRevenue,
      'totalCost': instance.totalCost,
      'totalProfit': instance.totalProfit,
      'averagePrice': instance.averagePrice,
    };

_$DailySalesStatsImpl _$$DailySalesStatsImplFromJson(
        Map<String, dynamic> json) =>
    _$DailySalesStatsImpl(
      date: DateTime.parse(json['date'] as String),
      transactionCount: (json['transactionCount'] as num).toInt(),
      revenue: (json['revenue'] as num).toDouble(),
      cost: (json['cost'] as num).toDouble(),
      adminFee: (json['adminFee'] as num).toDouble(),
      profit: (json['profit'] as num).toDouble(),
    );

Map<String, dynamic> _$$DailySalesStatsImplToJson(
        _$DailySalesStatsImpl instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'transactionCount': instance.transactionCount,
      'revenue': instance.revenue,
      'cost': instance.cost,
      'adminFee': instance.adminFee,
      'profit': instance.profit,
    };
