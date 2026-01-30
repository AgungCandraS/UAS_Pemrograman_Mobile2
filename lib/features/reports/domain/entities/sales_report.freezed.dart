// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sales_report.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SalesReport _$SalesReportFromJson(Map<String, dynamic> json) {
  return _SalesReport.fromJson(json);
}

/// @nodoc
mixin _$SalesReport {
  String get id => throw _privateConstructorUsedError;
  DateTime get startDate => throw _privateConstructorUsedError;
  DateTime get endDate => throw _privateConstructorUsedError;
  int get totalTransactions => throw _privateConstructorUsedError;
  double get totalRevenue => throw _privateConstructorUsedError;
  double get totalCost => throw _privateConstructorUsedError;
  double get totalAdminFee => throw _privateConstructorUsedError;
  double get totalProfit => throw _privateConstructorUsedError;
  List<ProductSalesSummary> get productSummaries =>
      throw _privateConstructorUsedError;
  List<DailySalesStats> get dailyStats => throw _privateConstructorUsedError;
  DateTime get generatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SalesReportCopyWith<SalesReport> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SalesReportCopyWith<$Res> {
  factory $SalesReportCopyWith(
          SalesReport value, $Res Function(SalesReport) then) =
      _$SalesReportCopyWithImpl<$Res, SalesReport>;
  @useResult
  $Res call(
      {String id,
      DateTime startDate,
      DateTime endDate,
      int totalTransactions,
      double totalRevenue,
      double totalCost,
      double totalAdminFee,
      double totalProfit,
      List<ProductSalesSummary> productSummaries,
      List<DailySalesStats> dailyStats,
      DateTime generatedAt});
}

/// @nodoc
class _$SalesReportCopyWithImpl<$Res, $Val extends SalesReport>
    implements $SalesReportCopyWith<$Res> {
  _$SalesReportCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? startDate = null,
    Object? endDate = null,
    Object? totalTransactions = null,
    Object? totalRevenue = null,
    Object? totalCost = null,
    Object? totalAdminFee = null,
    Object? totalProfit = null,
    Object? productSummaries = null,
    Object? dailyStats = null,
    Object? generatedAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: null == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      totalTransactions: null == totalTransactions
          ? _value.totalTransactions
          : totalTransactions // ignore: cast_nullable_to_non_nullable
              as int,
      totalRevenue: null == totalRevenue
          ? _value.totalRevenue
          : totalRevenue // ignore: cast_nullable_to_non_nullable
              as double,
      totalCost: null == totalCost
          ? _value.totalCost
          : totalCost // ignore: cast_nullable_to_non_nullable
              as double,
      totalAdminFee: null == totalAdminFee
          ? _value.totalAdminFee
          : totalAdminFee // ignore: cast_nullable_to_non_nullable
              as double,
      totalProfit: null == totalProfit
          ? _value.totalProfit
          : totalProfit // ignore: cast_nullable_to_non_nullable
              as double,
      productSummaries: null == productSummaries
          ? _value.productSummaries
          : productSummaries // ignore: cast_nullable_to_non_nullable
              as List<ProductSalesSummary>,
      dailyStats: null == dailyStats
          ? _value.dailyStats
          : dailyStats // ignore: cast_nullable_to_non_nullable
              as List<DailySalesStats>,
      generatedAt: null == generatedAt
          ? _value.generatedAt
          : generatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SalesReportImplCopyWith<$Res>
    implements $SalesReportCopyWith<$Res> {
  factory _$$SalesReportImplCopyWith(
          _$SalesReportImpl value, $Res Function(_$SalesReportImpl) then) =
      __$$SalesReportImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      DateTime startDate,
      DateTime endDate,
      int totalTransactions,
      double totalRevenue,
      double totalCost,
      double totalAdminFee,
      double totalProfit,
      List<ProductSalesSummary> productSummaries,
      List<DailySalesStats> dailyStats,
      DateTime generatedAt});
}

/// @nodoc
class __$$SalesReportImplCopyWithImpl<$Res>
    extends _$SalesReportCopyWithImpl<$Res, _$SalesReportImpl>
    implements _$$SalesReportImplCopyWith<$Res> {
  __$$SalesReportImplCopyWithImpl(
      _$SalesReportImpl _value, $Res Function(_$SalesReportImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? startDate = null,
    Object? endDate = null,
    Object? totalTransactions = null,
    Object? totalRevenue = null,
    Object? totalCost = null,
    Object? totalAdminFee = null,
    Object? totalProfit = null,
    Object? productSummaries = null,
    Object? dailyStats = null,
    Object? generatedAt = null,
  }) {
    return _then(_$SalesReportImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: null == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      totalTransactions: null == totalTransactions
          ? _value.totalTransactions
          : totalTransactions // ignore: cast_nullable_to_non_nullable
              as int,
      totalRevenue: null == totalRevenue
          ? _value.totalRevenue
          : totalRevenue // ignore: cast_nullable_to_non_nullable
              as double,
      totalCost: null == totalCost
          ? _value.totalCost
          : totalCost // ignore: cast_nullable_to_non_nullable
              as double,
      totalAdminFee: null == totalAdminFee
          ? _value.totalAdminFee
          : totalAdminFee // ignore: cast_nullable_to_non_nullable
              as double,
      totalProfit: null == totalProfit
          ? _value.totalProfit
          : totalProfit // ignore: cast_nullable_to_non_nullable
              as double,
      productSummaries: null == productSummaries
          ? _value._productSummaries
          : productSummaries // ignore: cast_nullable_to_non_nullable
              as List<ProductSalesSummary>,
      dailyStats: null == dailyStats
          ? _value._dailyStats
          : dailyStats // ignore: cast_nullable_to_non_nullable
              as List<DailySalesStats>,
      generatedAt: null == generatedAt
          ? _value.generatedAt
          : generatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SalesReportImpl implements _SalesReport {
  const _$SalesReportImpl(
      {required this.id,
      required this.startDate,
      required this.endDate,
      required this.totalTransactions,
      required this.totalRevenue,
      required this.totalCost,
      required this.totalAdminFee,
      required this.totalProfit,
      required final List<ProductSalesSummary> productSummaries,
      required final List<DailySalesStats> dailyStats,
      required this.generatedAt})
      : _productSummaries = productSummaries,
        _dailyStats = dailyStats;

  factory _$SalesReportImpl.fromJson(Map<String, dynamic> json) =>
      _$$SalesReportImplFromJson(json);

  @override
  final String id;
  @override
  final DateTime startDate;
  @override
  final DateTime endDate;
  @override
  final int totalTransactions;
  @override
  final double totalRevenue;
  @override
  final double totalCost;
  @override
  final double totalAdminFee;
  @override
  final double totalProfit;
  final List<ProductSalesSummary> _productSummaries;
  @override
  List<ProductSalesSummary> get productSummaries {
    if (_productSummaries is EqualUnmodifiableListView)
      return _productSummaries;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_productSummaries);
  }

  final List<DailySalesStats> _dailyStats;
  @override
  List<DailySalesStats> get dailyStats {
    if (_dailyStats is EqualUnmodifiableListView) return _dailyStats;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_dailyStats);
  }

  @override
  final DateTime generatedAt;

  @override
  String toString() {
    return 'SalesReport(id: $id, startDate: $startDate, endDate: $endDate, totalTransactions: $totalTransactions, totalRevenue: $totalRevenue, totalCost: $totalCost, totalAdminFee: $totalAdminFee, totalProfit: $totalProfit, productSummaries: $productSummaries, dailyStats: $dailyStats, generatedAt: $generatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SalesReportImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.totalTransactions, totalTransactions) ||
                other.totalTransactions == totalTransactions) &&
            (identical(other.totalRevenue, totalRevenue) ||
                other.totalRevenue == totalRevenue) &&
            (identical(other.totalCost, totalCost) ||
                other.totalCost == totalCost) &&
            (identical(other.totalAdminFee, totalAdminFee) ||
                other.totalAdminFee == totalAdminFee) &&
            (identical(other.totalProfit, totalProfit) ||
                other.totalProfit == totalProfit) &&
            const DeepCollectionEquality()
                .equals(other._productSummaries, _productSummaries) &&
            const DeepCollectionEquality()
                .equals(other._dailyStats, _dailyStats) &&
            (identical(other.generatedAt, generatedAt) ||
                other.generatedAt == generatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      startDate,
      endDate,
      totalTransactions,
      totalRevenue,
      totalCost,
      totalAdminFee,
      totalProfit,
      const DeepCollectionEquality().hash(_productSummaries),
      const DeepCollectionEquality().hash(_dailyStats),
      generatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SalesReportImplCopyWith<_$SalesReportImpl> get copyWith =>
      __$$SalesReportImplCopyWithImpl<_$SalesReportImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SalesReportImplToJson(
      this,
    );
  }
}

abstract class _SalesReport implements SalesReport {
  const factory _SalesReport(
      {required final String id,
      required final DateTime startDate,
      required final DateTime endDate,
      required final int totalTransactions,
      required final double totalRevenue,
      required final double totalCost,
      required final double totalAdminFee,
      required final double totalProfit,
      required final List<ProductSalesSummary> productSummaries,
      required final List<DailySalesStats> dailyStats,
      required final DateTime generatedAt}) = _$SalesReportImpl;

  factory _SalesReport.fromJson(Map<String, dynamic> json) =
      _$SalesReportImpl.fromJson;

  @override
  String get id;
  @override
  DateTime get startDate;
  @override
  DateTime get endDate;
  @override
  int get totalTransactions;
  @override
  double get totalRevenue;
  @override
  double get totalCost;
  @override
  double get totalAdminFee;
  @override
  double get totalProfit;
  @override
  List<ProductSalesSummary> get productSummaries;
  @override
  List<DailySalesStats> get dailyStats;
  @override
  DateTime get generatedAt;
  @override
  @JsonKey(ignore: true)
  _$$SalesReportImplCopyWith<_$SalesReportImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ProductSalesSummary _$ProductSalesSummaryFromJson(Map<String, dynamic> json) {
  return _ProductSalesSummary.fromJson(json);
}

/// @nodoc
mixin _$ProductSalesSummary {
  String get productName => throw _privateConstructorUsedError;
  int get totalQuantity => throw _privateConstructorUsedError;
  double get totalRevenue => throw _privateConstructorUsedError;
  double get totalCost => throw _privateConstructorUsedError;
  double get totalProfit => throw _privateConstructorUsedError;
  double get averagePrice => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ProductSalesSummaryCopyWith<ProductSalesSummary> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProductSalesSummaryCopyWith<$Res> {
  factory $ProductSalesSummaryCopyWith(
          ProductSalesSummary value, $Res Function(ProductSalesSummary) then) =
      _$ProductSalesSummaryCopyWithImpl<$Res, ProductSalesSummary>;
  @useResult
  $Res call(
      {String productName,
      int totalQuantity,
      double totalRevenue,
      double totalCost,
      double totalProfit,
      double averagePrice});
}

/// @nodoc
class _$ProductSalesSummaryCopyWithImpl<$Res, $Val extends ProductSalesSummary>
    implements $ProductSalesSummaryCopyWith<$Res> {
  _$ProductSalesSummaryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productName = null,
    Object? totalQuantity = null,
    Object? totalRevenue = null,
    Object? totalCost = null,
    Object? totalProfit = null,
    Object? averagePrice = null,
  }) {
    return _then(_value.copyWith(
      productName: null == productName
          ? _value.productName
          : productName // ignore: cast_nullable_to_non_nullable
              as String,
      totalQuantity: null == totalQuantity
          ? _value.totalQuantity
          : totalQuantity // ignore: cast_nullable_to_non_nullable
              as int,
      totalRevenue: null == totalRevenue
          ? _value.totalRevenue
          : totalRevenue // ignore: cast_nullable_to_non_nullable
              as double,
      totalCost: null == totalCost
          ? _value.totalCost
          : totalCost // ignore: cast_nullable_to_non_nullable
              as double,
      totalProfit: null == totalProfit
          ? _value.totalProfit
          : totalProfit // ignore: cast_nullable_to_non_nullable
              as double,
      averagePrice: null == averagePrice
          ? _value.averagePrice
          : averagePrice // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ProductSalesSummaryImplCopyWith<$Res>
    implements $ProductSalesSummaryCopyWith<$Res> {
  factory _$$ProductSalesSummaryImplCopyWith(_$ProductSalesSummaryImpl value,
          $Res Function(_$ProductSalesSummaryImpl) then) =
      __$$ProductSalesSummaryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String productName,
      int totalQuantity,
      double totalRevenue,
      double totalCost,
      double totalProfit,
      double averagePrice});
}

/// @nodoc
class __$$ProductSalesSummaryImplCopyWithImpl<$Res>
    extends _$ProductSalesSummaryCopyWithImpl<$Res, _$ProductSalesSummaryImpl>
    implements _$$ProductSalesSummaryImplCopyWith<$Res> {
  __$$ProductSalesSummaryImplCopyWithImpl(_$ProductSalesSummaryImpl _value,
      $Res Function(_$ProductSalesSummaryImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productName = null,
    Object? totalQuantity = null,
    Object? totalRevenue = null,
    Object? totalCost = null,
    Object? totalProfit = null,
    Object? averagePrice = null,
  }) {
    return _then(_$ProductSalesSummaryImpl(
      productName: null == productName
          ? _value.productName
          : productName // ignore: cast_nullable_to_non_nullable
              as String,
      totalQuantity: null == totalQuantity
          ? _value.totalQuantity
          : totalQuantity // ignore: cast_nullable_to_non_nullable
              as int,
      totalRevenue: null == totalRevenue
          ? _value.totalRevenue
          : totalRevenue // ignore: cast_nullable_to_non_nullable
              as double,
      totalCost: null == totalCost
          ? _value.totalCost
          : totalCost // ignore: cast_nullable_to_non_nullable
              as double,
      totalProfit: null == totalProfit
          ? _value.totalProfit
          : totalProfit // ignore: cast_nullable_to_non_nullable
              as double,
      averagePrice: null == averagePrice
          ? _value.averagePrice
          : averagePrice // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ProductSalesSummaryImpl implements _ProductSalesSummary {
  const _$ProductSalesSummaryImpl(
      {required this.productName,
      required this.totalQuantity,
      required this.totalRevenue,
      required this.totalCost,
      required this.totalProfit,
      required this.averagePrice});

  factory _$ProductSalesSummaryImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProductSalesSummaryImplFromJson(json);

  @override
  final String productName;
  @override
  final int totalQuantity;
  @override
  final double totalRevenue;
  @override
  final double totalCost;
  @override
  final double totalProfit;
  @override
  final double averagePrice;

  @override
  String toString() {
    return 'ProductSalesSummary(productName: $productName, totalQuantity: $totalQuantity, totalRevenue: $totalRevenue, totalCost: $totalCost, totalProfit: $totalProfit, averagePrice: $averagePrice)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProductSalesSummaryImpl &&
            (identical(other.productName, productName) ||
                other.productName == productName) &&
            (identical(other.totalQuantity, totalQuantity) ||
                other.totalQuantity == totalQuantity) &&
            (identical(other.totalRevenue, totalRevenue) ||
                other.totalRevenue == totalRevenue) &&
            (identical(other.totalCost, totalCost) ||
                other.totalCost == totalCost) &&
            (identical(other.totalProfit, totalProfit) ||
                other.totalProfit == totalProfit) &&
            (identical(other.averagePrice, averagePrice) ||
                other.averagePrice == averagePrice));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, productName, totalQuantity,
      totalRevenue, totalCost, totalProfit, averagePrice);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ProductSalesSummaryImplCopyWith<_$ProductSalesSummaryImpl> get copyWith =>
      __$$ProductSalesSummaryImplCopyWithImpl<_$ProductSalesSummaryImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProductSalesSummaryImplToJson(
      this,
    );
  }
}

abstract class _ProductSalesSummary implements ProductSalesSummary {
  const factory _ProductSalesSummary(
      {required final String productName,
      required final int totalQuantity,
      required final double totalRevenue,
      required final double totalCost,
      required final double totalProfit,
      required final double averagePrice}) = _$ProductSalesSummaryImpl;

  factory _ProductSalesSummary.fromJson(Map<String, dynamic> json) =
      _$ProductSalesSummaryImpl.fromJson;

  @override
  String get productName;
  @override
  int get totalQuantity;
  @override
  double get totalRevenue;
  @override
  double get totalCost;
  @override
  double get totalProfit;
  @override
  double get averagePrice;
  @override
  @JsonKey(ignore: true)
  _$$ProductSalesSummaryImplCopyWith<_$ProductSalesSummaryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DailySalesStats _$DailySalesStatsFromJson(Map<String, dynamic> json) {
  return _DailySalesStats.fromJson(json);
}

/// @nodoc
mixin _$DailySalesStats {
  DateTime get date => throw _privateConstructorUsedError;
  int get transactionCount => throw _privateConstructorUsedError;
  double get revenue => throw _privateConstructorUsedError;
  double get cost => throw _privateConstructorUsedError;
  double get adminFee => throw _privateConstructorUsedError;
  double get profit => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $DailySalesStatsCopyWith<DailySalesStats> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DailySalesStatsCopyWith<$Res> {
  factory $DailySalesStatsCopyWith(
          DailySalesStats value, $Res Function(DailySalesStats) then) =
      _$DailySalesStatsCopyWithImpl<$Res, DailySalesStats>;
  @useResult
  $Res call(
      {DateTime date,
      int transactionCount,
      double revenue,
      double cost,
      double adminFee,
      double profit});
}

/// @nodoc
class _$DailySalesStatsCopyWithImpl<$Res, $Val extends DailySalesStats>
    implements $DailySalesStatsCopyWith<$Res> {
  _$DailySalesStatsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? transactionCount = null,
    Object? revenue = null,
    Object? cost = null,
    Object? adminFee = null,
    Object? profit = null,
  }) {
    return _then(_value.copyWith(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      transactionCount: null == transactionCount
          ? _value.transactionCount
          : transactionCount // ignore: cast_nullable_to_non_nullable
              as int,
      revenue: null == revenue
          ? _value.revenue
          : revenue // ignore: cast_nullable_to_non_nullable
              as double,
      cost: null == cost
          ? _value.cost
          : cost // ignore: cast_nullable_to_non_nullable
              as double,
      adminFee: null == adminFee
          ? _value.adminFee
          : adminFee // ignore: cast_nullable_to_non_nullable
              as double,
      profit: null == profit
          ? _value.profit
          : profit // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DailySalesStatsImplCopyWith<$Res>
    implements $DailySalesStatsCopyWith<$Res> {
  factory _$$DailySalesStatsImplCopyWith(_$DailySalesStatsImpl value,
          $Res Function(_$DailySalesStatsImpl) then) =
      __$$DailySalesStatsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {DateTime date,
      int transactionCount,
      double revenue,
      double cost,
      double adminFee,
      double profit});
}

/// @nodoc
class __$$DailySalesStatsImplCopyWithImpl<$Res>
    extends _$DailySalesStatsCopyWithImpl<$Res, _$DailySalesStatsImpl>
    implements _$$DailySalesStatsImplCopyWith<$Res> {
  __$$DailySalesStatsImplCopyWithImpl(
      _$DailySalesStatsImpl _value, $Res Function(_$DailySalesStatsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? transactionCount = null,
    Object? revenue = null,
    Object? cost = null,
    Object? adminFee = null,
    Object? profit = null,
  }) {
    return _then(_$DailySalesStatsImpl(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      transactionCount: null == transactionCount
          ? _value.transactionCount
          : transactionCount // ignore: cast_nullable_to_non_nullable
              as int,
      revenue: null == revenue
          ? _value.revenue
          : revenue // ignore: cast_nullable_to_non_nullable
              as double,
      cost: null == cost
          ? _value.cost
          : cost // ignore: cast_nullable_to_non_nullable
              as double,
      adminFee: null == adminFee
          ? _value.adminFee
          : adminFee // ignore: cast_nullable_to_non_nullable
              as double,
      profit: null == profit
          ? _value.profit
          : profit // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DailySalesStatsImpl implements _DailySalesStats {
  const _$DailySalesStatsImpl(
      {required this.date,
      required this.transactionCount,
      required this.revenue,
      required this.cost,
      required this.adminFee,
      required this.profit});

  factory _$DailySalesStatsImpl.fromJson(Map<String, dynamic> json) =>
      _$$DailySalesStatsImplFromJson(json);

  @override
  final DateTime date;
  @override
  final int transactionCount;
  @override
  final double revenue;
  @override
  final double cost;
  @override
  final double adminFee;
  @override
  final double profit;

  @override
  String toString() {
    return 'DailySalesStats(date: $date, transactionCount: $transactionCount, revenue: $revenue, cost: $cost, adminFee: $adminFee, profit: $profit)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DailySalesStatsImpl &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.transactionCount, transactionCount) ||
                other.transactionCount == transactionCount) &&
            (identical(other.revenue, revenue) || other.revenue == revenue) &&
            (identical(other.cost, cost) || other.cost == cost) &&
            (identical(other.adminFee, adminFee) ||
                other.adminFee == adminFee) &&
            (identical(other.profit, profit) || other.profit == profit));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, date, transactionCount, revenue, cost, adminFee, profit);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DailySalesStatsImplCopyWith<_$DailySalesStatsImpl> get copyWith =>
      __$$DailySalesStatsImplCopyWithImpl<_$DailySalesStatsImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DailySalesStatsImplToJson(
      this,
    );
  }
}

abstract class _DailySalesStats implements DailySalesStats {
  const factory _DailySalesStats(
      {required final DateTime date,
      required final int transactionCount,
      required final double revenue,
      required final double cost,
      required final double adminFee,
      required final double profit}) = _$DailySalesStatsImpl;

  factory _DailySalesStats.fromJson(Map<String, dynamic> json) =
      _$DailySalesStatsImpl.fromJson;

  @override
  DateTime get date;
  @override
  int get transactionCount;
  @override
  double get revenue;
  @override
  double get cost;
  @override
  double get adminFee;
  @override
  double get profit;
  @override
  @JsonKey(ignore: true)
  _$$DailySalesStatsImplCopyWith<_$DailySalesStatsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
