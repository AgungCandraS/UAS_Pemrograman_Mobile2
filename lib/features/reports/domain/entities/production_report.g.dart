// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'production_report.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProductionReportImpl _$$ProductionReportImplFromJson(
        Map<String, dynamic> json) =>
    _$ProductionReportImpl(
      id: json['id'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      totalItems: (json['totalItems'] as num).toInt(),
      completedItems: (json['completedItems'] as num).toInt(),
      pendingItems: (json['pendingItems'] as num).toInt(),
      cancelledItems: (json['cancelledItems'] as num).toInt(),
      completionRate: (json['completionRate'] as num).toDouble(),
      dailyProduction: (json['dailyProduction'] as List<dynamic>)
          .map((e) => DailyProduction.fromJson(e as Map<String, dynamic>))
          .toList(),
      statusBreakdown: (json['statusBreakdown'] as List<dynamic>)
          .map((e) => ProductionByStatus.fromJson(e as Map<String, dynamic>))
          .toList(),
      employeeProductions: (json['employeeProductions'] as List<dynamic>)
          .map((e) => EmployeeProduction.fromJson(e as Map<String, dynamic>))
          .toList(),
      averageCompletionTime: (json['averageCompletionTime'] as num).toDouble(),
      generatedAt: DateTime.parse(json['generatedAt'] as String),
    );

Map<String, dynamic> _$$ProductionReportImplToJson(
        _$ProductionReportImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate.toIso8601String(),
      'totalItems': instance.totalItems,
      'completedItems': instance.completedItems,
      'pendingItems': instance.pendingItems,
      'cancelledItems': instance.cancelledItems,
      'completionRate': instance.completionRate,
      'dailyProduction': instance.dailyProduction,
      'statusBreakdown': instance.statusBreakdown,
      'employeeProductions': instance.employeeProductions,
      'averageCompletionTime': instance.averageCompletionTime,
      'generatedAt': instance.generatedAt.toIso8601String(),
    };

_$DailyProductionImpl _$$DailyProductionImplFromJson(
        Map<String, dynamic> json) =>
    _$DailyProductionImpl(
      date: DateTime.parse(json['date'] as String),
      totalItems: (json['totalItems'] as num).toInt(),
      completedItems: (json['completedItems'] as num).toInt(),
      pendingItems: (json['pendingItems'] as num).toInt(),
      completionRate: (json['completionRate'] as num).toDouble(),
    );

Map<String, dynamic> _$$DailyProductionImplToJson(
        _$DailyProductionImpl instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'totalItems': instance.totalItems,
      'completedItems': instance.completedItems,
      'pendingItems': instance.pendingItems,
      'completionRate': instance.completionRate,
    };

_$ProductionByStatusImpl _$$ProductionByStatusImplFromJson(
        Map<String, dynamic> json) =>
    _$ProductionByStatusImpl(
      status: json['status'] as String,
      count: (json['count'] as num).toInt(),
      percentage: (json['percentage'] as num).toDouble(),
    );

Map<String, dynamic> _$$ProductionByStatusImplToJson(
        _$ProductionByStatusImpl instance) =>
    <String, dynamic>{
      'status': instance.status,
      'count': instance.count,
      'percentage': instance.percentage,
    };

_$EmployeeProductionImpl _$$EmployeeProductionImplFromJson(
        Map<String, dynamic> json) =>
    _$EmployeeProductionImpl(
      employeeId: json['employeeId'] as String,
      employeeName: json['employeeName'] as String,
      department: json['department'] as String,
      totalPcs: (json['totalPcs'] as num).toInt(),
      items: (json['items'] as List<dynamic>)
          .map((e) => ProductionItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalEarnings: (json['totalEarnings'] as num).toDouble(),
    );

Map<String, dynamic> _$$EmployeeProductionImplToJson(
        _$EmployeeProductionImpl instance) =>
    <String, dynamic>{
      'employeeId': instance.employeeId,
      'employeeName': instance.employeeName,
      'department': instance.department,
      'totalPcs': instance.totalPcs,
      'items': instance.items,
      'totalEarnings': instance.totalEarnings,
    };

_$ProductionItemImpl _$$ProductionItemImplFromJson(Map<String, dynamic> json) =>
    _$ProductionItemImpl(
      productName: json['productName'] as String,
      department: json['department'] as String,
      pcs: (json['pcs'] as num).toInt(),
      ratePerPcs: (json['ratePerPcs'] as num).toDouble(),
      earnings: (json['earnings'] as num).toDouble(),
      losin: json['losin'] as String?,
    );

Map<String, dynamic> _$$ProductionItemImplToJson(
        _$ProductionItemImpl instance) =>
    <String, dynamic>{
      'productName': instance.productName,
      'department': instance.department,
      'pcs': instance.pcs,
      'ratePerPcs': instance.ratePerPcs,
      'earnings': instance.earnings,
      'losin': instance.losin,
    };
