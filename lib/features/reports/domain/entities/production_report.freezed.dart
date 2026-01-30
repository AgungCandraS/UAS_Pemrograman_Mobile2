// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'production_report.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ProductionReport _$ProductionReportFromJson(Map<String, dynamic> json) {
  return _ProductionReport.fromJson(json);
}

/// @nodoc
mixin _$ProductionReport {
  String get id => throw _privateConstructorUsedError;
  DateTime get startDate => throw _privateConstructorUsedError;
  DateTime get endDate => throw _privateConstructorUsedError;
  int get totalItems => throw _privateConstructorUsedError;
  int get completedItems => throw _privateConstructorUsedError;
  int get pendingItems => throw _privateConstructorUsedError;
  int get cancelledItems => throw _privateConstructorUsedError;
  double get completionRate => throw _privateConstructorUsedError;
  List<DailyProduction> get dailyProduction =>
      throw _privateConstructorUsedError;
  List<ProductionByStatus> get statusBreakdown =>
      throw _privateConstructorUsedError;
  List<EmployeeProduction> get employeeProductions =>
      throw _privateConstructorUsedError;
  double get averageCompletionTime => throw _privateConstructorUsedError;
  DateTime get generatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ProductionReportCopyWith<ProductionReport> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProductionReportCopyWith<$Res> {
  factory $ProductionReportCopyWith(
          ProductionReport value, $Res Function(ProductionReport) then) =
      _$ProductionReportCopyWithImpl<$Res, ProductionReport>;
  @useResult
  $Res call(
      {String id,
      DateTime startDate,
      DateTime endDate,
      int totalItems,
      int completedItems,
      int pendingItems,
      int cancelledItems,
      double completionRate,
      List<DailyProduction> dailyProduction,
      List<ProductionByStatus> statusBreakdown,
      List<EmployeeProduction> employeeProductions,
      double averageCompletionTime,
      DateTime generatedAt});
}

/// @nodoc
class _$ProductionReportCopyWithImpl<$Res, $Val extends ProductionReport>
    implements $ProductionReportCopyWith<$Res> {
  _$ProductionReportCopyWithImpl(this._value, this._then);

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
    Object? totalItems = null,
    Object? completedItems = null,
    Object? pendingItems = null,
    Object? cancelledItems = null,
    Object? completionRate = null,
    Object? dailyProduction = null,
    Object? statusBreakdown = null,
    Object? employeeProductions = null,
    Object? averageCompletionTime = null,
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
      totalItems: null == totalItems
          ? _value.totalItems
          : totalItems // ignore: cast_nullable_to_non_nullable
              as int,
      completedItems: null == completedItems
          ? _value.completedItems
          : completedItems // ignore: cast_nullable_to_non_nullable
              as int,
      pendingItems: null == pendingItems
          ? _value.pendingItems
          : pendingItems // ignore: cast_nullable_to_non_nullable
              as int,
      cancelledItems: null == cancelledItems
          ? _value.cancelledItems
          : cancelledItems // ignore: cast_nullable_to_non_nullable
              as int,
      completionRate: null == completionRate
          ? _value.completionRate
          : completionRate // ignore: cast_nullable_to_non_nullable
              as double,
      dailyProduction: null == dailyProduction
          ? _value.dailyProduction
          : dailyProduction // ignore: cast_nullable_to_non_nullable
              as List<DailyProduction>,
      statusBreakdown: null == statusBreakdown
          ? _value.statusBreakdown
          : statusBreakdown // ignore: cast_nullable_to_non_nullable
              as List<ProductionByStatus>,
      employeeProductions: null == employeeProductions
          ? _value.employeeProductions
          : employeeProductions // ignore: cast_nullable_to_non_nullable
              as List<EmployeeProduction>,
      averageCompletionTime: null == averageCompletionTime
          ? _value.averageCompletionTime
          : averageCompletionTime // ignore: cast_nullable_to_non_nullable
              as double,
      generatedAt: null == generatedAt
          ? _value.generatedAt
          : generatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ProductionReportImplCopyWith<$Res>
    implements $ProductionReportCopyWith<$Res> {
  factory _$$ProductionReportImplCopyWith(_$ProductionReportImpl value,
          $Res Function(_$ProductionReportImpl) then) =
      __$$ProductionReportImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      DateTime startDate,
      DateTime endDate,
      int totalItems,
      int completedItems,
      int pendingItems,
      int cancelledItems,
      double completionRate,
      List<DailyProduction> dailyProduction,
      List<ProductionByStatus> statusBreakdown,
      List<EmployeeProduction> employeeProductions,
      double averageCompletionTime,
      DateTime generatedAt});
}

/// @nodoc
class __$$ProductionReportImplCopyWithImpl<$Res>
    extends _$ProductionReportCopyWithImpl<$Res, _$ProductionReportImpl>
    implements _$$ProductionReportImplCopyWith<$Res> {
  __$$ProductionReportImplCopyWithImpl(_$ProductionReportImpl _value,
      $Res Function(_$ProductionReportImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? startDate = null,
    Object? endDate = null,
    Object? totalItems = null,
    Object? completedItems = null,
    Object? pendingItems = null,
    Object? cancelledItems = null,
    Object? completionRate = null,
    Object? dailyProduction = null,
    Object? statusBreakdown = null,
    Object? employeeProductions = null,
    Object? averageCompletionTime = null,
    Object? generatedAt = null,
  }) {
    return _then(_$ProductionReportImpl(
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
      totalItems: null == totalItems
          ? _value.totalItems
          : totalItems // ignore: cast_nullable_to_non_nullable
              as int,
      completedItems: null == completedItems
          ? _value.completedItems
          : completedItems // ignore: cast_nullable_to_non_nullable
              as int,
      pendingItems: null == pendingItems
          ? _value.pendingItems
          : pendingItems // ignore: cast_nullable_to_non_nullable
              as int,
      cancelledItems: null == cancelledItems
          ? _value.cancelledItems
          : cancelledItems // ignore: cast_nullable_to_non_nullable
              as int,
      completionRate: null == completionRate
          ? _value.completionRate
          : completionRate // ignore: cast_nullable_to_non_nullable
              as double,
      dailyProduction: null == dailyProduction
          ? _value._dailyProduction
          : dailyProduction // ignore: cast_nullable_to_non_nullable
              as List<DailyProduction>,
      statusBreakdown: null == statusBreakdown
          ? _value._statusBreakdown
          : statusBreakdown // ignore: cast_nullable_to_non_nullable
              as List<ProductionByStatus>,
      employeeProductions: null == employeeProductions
          ? _value._employeeProductions
          : employeeProductions // ignore: cast_nullable_to_non_nullable
              as List<EmployeeProduction>,
      averageCompletionTime: null == averageCompletionTime
          ? _value.averageCompletionTime
          : averageCompletionTime // ignore: cast_nullable_to_non_nullable
              as double,
      generatedAt: null == generatedAt
          ? _value.generatedAt
          : generatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ProductionReportImpl implements _ProductionReport {
  const _$ProductionReportImpl(
      {required this.id,
      required this.startDate,
      required this.endDate,
      required this.totalItems,
      required this.completedItems,
      required this.pendingItems,
      required this.cancelledItems,
      required this.completionRate,
      required final List<DailyProduction> dailyProduction,
      required final List<ProductionByStatus> statusBreakdown,
      required final List<EmployeeProduction> employeeProductions,
      required this.averageCompletionTime,
      required this.generatedAt})
      : _dailyProduction = dailyProduction,
        _statusBreakdown = statusBreakdown,
        _employeeProductions = employeeProductions;

  factory _$ProductionReportImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProductionReportImplFromJson(json);

  @override
  final String id;
  @override
  final DateTime startDate;
  @override
  final DateTime endDate;
  @override
  final int totalItems;
  @override
  final int completedItems;
  @override
  final int pendingItems;
  @override
  final int cancelledItems;
  @override
  final double completionRate;
  final List<DailyProduction> _dailyProduction;
  @override
  List<DailyProduction> get dailyProduction {
    if (_dailyProduction is EqualUnmodifiableListView) return _dailyProduction;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_dailyProduction);
  }

  final List<ProductionByStatus> _statusBreakdown;
  @override
  List<ProductionByStatus> get statusBreakdown {
    if (_statusBreakdown is EqualUnmodifiableListView) return _statusBreakdown;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_statusBreakdown);
  }

  final List<EmployeeProduction> _employeeProductions;
  @override
  List<EmployeeProduction> get employeeProductions {
    if (_employeeProductions is EqualUnmodifiableListView)
      return _employeeProductions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_employeeProductions);
  }

  @override
  final double averageCompletionTime;
  @override
  final DateTime generatedAt;

  @override
  String toString() {
    return 'ProductionReport(id: $id, startDate: $startDate, endDate: $endDate, totalItems: $totalItems, completedItems: $completedItems, pendingItems: $pendingItems, cancelledItems: $cancelledItems, completionRate: $completionRate, dailyProduction: $dailyProduction, statusBreakdown: $statusBreakdown, employeeProductions: $employeeProductions, averageCompletionTime: $averageCompletionTime, generatedAt: $generatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProductionReportImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.totalItems, totalItems) ||
                other.totalItems == totalItems) &&
            (identical(other.completedItems, completedItems) ||
                other.completedItems == completedItems) &&
            (identical(other.pendingItems, pendingItems) ||
                other.pendingItems == pendingItems) &&
            (identical(other.cancelledItems, cancelledItems) ||
                other.cancelledItems == cancelledItems) &&
            (identical(other.completionRate, completionRate) ||
                other.completionRate == completionRate) &&
            const DeepCollectionEquality()
                .equals(other._dailyProduction, _dailyProduction) &&
            const DeepCollectionEquality()
                .equals(other._statusBreakdown, _statusBreakdown) &&
            const DeepCollectionEquality()
                .equals(other._employeeProductions, _employeeProductions) &&
            (identical(other.averageCompletionTime, averageCompletionTime) ||
                other.averageCompletionTime == averageCompletionTime) &&
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
      totalItems,
      completedItems,
      pendingItems,
      cancelledItems,
      completionRate,
      const DeepCollectionEquality().hash(_dailyProduction),
      const DeepCollectionEquality().hash(_statusBreakdown),
      const DeepCollectionEquality().hash(_employeeProductions),
      averageCompletionTime,
      generatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ProductionReportImplCopyWith<_$ProductionReportImpl> get copyWith =>
      __$$ProductionReportImplCopyWithImpl<_$ProductionReportImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProductionReportImplToJson(
      this,
    );
  }
}

abstract class _ProductionReport implements ProductionReport {
  const factory _ProductionReport(
      {required final String id,
      required final DateTime startDate,
      required final DateTime endDate,
      required final int totalItems,
      required final int completedItems,
      required final int pendingItems,
      required final int cancelledItems,
      required final double completionRate,
      required final List<DailyProduction> dailyProduction,
      required final List<ProductionByStatus> statusBreakdown,
      required final List<EmployeeProduction> employeeProductions,
      required final double averageCompletionTime,
      required final DateTime generatedAt}) = _$ProductionReportImpl;

  factory _ProductionReport.fromJson(Map<String, dynamic> json) =
      _$ProductionReportImpl.fromJson;

  @override
  String get id;
  @override
  DateTime get startDate;
  @override
  DateTime get endDate;
  @override
  int get totalItems;
  @override
  int get completedItems;
  @override
  int get pendingItems;
  @override
  int get cancelledItems;
  @override
  double get completionRate;
  @override
  List<DailyProduction> get dailyProduction;
  @override
  List<ProductionByStatus> get statusBreakdown;
  @override
  List<EmployeeProduction> get employeeProductions;
  @override
  double get averageCompletionTime;
  @override
  DateTime get generatedAt;
  @override
  @JsonKey(ignore: true)
  _$$ProductionReportImplCopyWith<_$ProductionReportImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DailyProduction _$DailyProductionFromJson(Map<String, dynamic> json) {
  return _DailyProduction.fromJson(json);
}

/// @nodoc
mixin _$DailyProduction {
  DateTime get date => throw _privateConstructorUsedError;
  int get totalItems => throw _privateConstructorUsedError;
  int get completedItems => throw _privateConstructorUsedError;
  int get pendingItems => throw _privateConstructorUsedError;
  double get completionRate => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $DailyProductionCopyWith<DailyProduction> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DailyProductionCopyWith<$Res> {
  factory $DailyProductionCopyWith(
          DailyProduction value, $Res Function(DailyProduction) then) =
      _$DailyProductionCopyWithImpl<$Res, DailyProduction>;
  @useResult
  $Res call(
      {DateTime date,
      int totalItems,
      int completedItems,
      int pendingItems,
      double completionRate});
}

/// @nodoc
class _$DailyProductionCopyWithImpl<$Res, $Val extends DailyProduction>
    implements $DailyProductionCopyWith<$Res> {
  _$DailyProductionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? totalItems = null,
    Object? completedItems = null,
    Object? pendingItems = null,
    Object? completionRate = null,
  }) {
    return _then(_value.copyWith(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      totalItems: null == totalItems
          ? _value.totalItems
          : totalItems // ignore: cast_nullable_to_non_nullable
              as int,
      completedItems: null == completedItems
          ? _value.completedItems
          : completedItems // ignore: cast_nullable_to_non_nullable
              as int,
      pendingItems: null == pendingItems
          ? _value.pendingItems
          : pendingItems // ignore: cast_nullable_to_non_nullable
              as int,
      completionRate: null == completionRate
          ? _value.completionRate
          : completionRate // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DailyProductionImplCopyWith<$Res>
    implements $DailyProductionCopyWith<$Res> {
  factory _$$DailyProductionImplCopyWith(_$DailyProductionImpl value,
          $Res Function(_$DailyProductionImpl) then) =
      __$$DailyProductionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {DateTime date,
      int totalItems,
      int completedItems,
      int pendingItems,
      double completionRate});
}

/// @nodoc
class __$$DailyProductionImplCopyWithImpl<$Res>
    extends _$DailyProductionCopyWithImpl<$Res, _$DailyProductionImpl>
    implements _$$DailyProductionImplCopyWith<$Res> {
  __$$DailyProductionImplCopyWithImpl(
      _$DailyProductionImpl _value, $Res Function(_$DailyProductionImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? totalItems = null,
    Object? completedItems = null,
    Object? pendingItems = null,
    Object? completionRate = null,
  }) {
    return _then(_$DailyProductionImpl(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      totalItems: null == totalItems
          ? _value.totalItems
          : totalItems // ignore: cast_nullable_to_non_nullable
              as int,
      completedItems: null == completedItems
          ? _value.completedItems
          : completedItems // ignore: cast_nullable_to_non_nullable
              as int,
      pendingItems: null == pendingItems
          ? _value.pendingItems
          : pendingItems // ignore: cast_nullable_to_non_nullable
              as int,
      completionRate: null == completionRate
          ? _value.completionRate
          : completionRate // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DailyProductionImpl implements _DailyProduction {
  const _$DailyProductionImpl(
      {required this.date,
      required this.totalItems,
      required this.completedItems,
      required this.pendingItems,
      required this.completionRate});

  factory _$DailyProductionImpl.fromJson(Map<String, dynamic> json) =>
      _$$DailyProductionImplFromJson(json);

  @override
  final DateTime date;
  @override
  final int totalItems;
  @override
  final int completedItems;
  @override
  final int pendingItems;
  @override
  final double completionRate;

  @override
  String toString() {
    return 'DailyProduction(date: $date, totalItems: $totalItems, completedItems: $completedItems, pendingItems: $pendingItems, completionRate: $completionRate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DailyProductionImpl &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.totalItems, totalItems) ||
                other.totalItems == totalItems) &&
            (identical(other.completedItems, completedItems) ||
                other.completedItems == completedItems) &&
            (identical(other.pendingItems, pendingItems) ||
                other.pendingItems == pendingItems) &&
            (identical(other.completionRate, completionRate) ||
                other.completionRate == completionRate));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, date, totalItems, completedItems,
      pendingItems, completionRate);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DailyProductionImplCopyWith<_$DailyProductionImpl> get copyWith =>
      __$$DailyProductionImplCopyWithImpl<_$DailyProductionImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DailyProductionImplToJson(
      this,
    );
  }
}

abstract class _DailyProduction implements DailyProduction {
  const factory _DailyProduction(
      {required final DateTime date,
      required final int totalItems,
      required final int completedItems,
      required final int pendingItems,
      required final double completionRate}) = _$DailyProductionImpl;

  factory _DailyProduction.fromJson(Map<String, dynamic> json) =
      _$DailyProductionImpl.fromJson;

  @override
  DateTime get date;
  @override
  int get totalItems;
  @override
  int get completedItems;
  @override
  int get pendingItems;
  @override
  double get completionRate;
  @override
  @JsonKey(ignore: true)
  _$$DailyProductionImplCopyWith<_$DailyProductionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ProductionByStatus _$ProductionByStatusFromJson(Map<String, dynamic> json) {
  return _ProductionByStatus.fromJson(json);
}

/// @nodoc
mixin _$ProductionByStatus {
  String get status => throw _privateConstructorUsedError;
  int get count => throw _privateConstructorUsedError;
  double get percentage => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ProductionByStatusCopyWith<ProductionByStatus> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProductionByStatusCopyWith<$Res> {
  factory $ProductionByStatusCopyWith(
          ProductionByStatus value, $Res Function(ProductionByStatus) then) =
      _$ProductionByStatusCopyWithImpl<$Res, ProductionByStatus>;
  @useResult
  $Res call({String status, int count, double percentage});
}

/// @nodoc
class _$ProductionByStatusCopyWithImpl<$Res, $Val extends ProductionByStatus>
    implements $ProductionByStatusCopyWith<$Res> {
  _$ProductionByStatusCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? count = null,
    Object? percentage = null,
  }) {
    return _then(_value.copyWith(
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      count: null == count
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int,
      percentage: null == percentage
          ? _value.percentage
          : percentage // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ProductionByStatusImplCopyWith<$Res>
    implements $ProductionByStatusCopyWith<$Res> {
  factory _$$ProductionByStatusImplCopyWith(_$ProductionByStatusImpl value,
          $Res Function(_$ProductionByStatusImpl) then) =
      __$$ProductionByStatusImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String status, int count, double percentage});
}

/// @nodoc
class __$$ProductionByStatusImplCopyWithImpl<$Res>
    extends _$ProductionByStatusCopyWithImpl<$Res, _$ProductionByStatusImpl>
    implements _$$ProductionByStatusImplCopyWith<$Res> {
  __$$ProductionByStatusImplCopyWithImpl(_$ProductionByStatusImpl _value,
      $Res Function(_$ProductionByStatusImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? count = null,
    Object? percentage = null,
  }) {
    return _then(_$ProductionByStatusImpl(
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      count: null == count
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int,
      percentage: null == percentage
          ? _value.percentage
          : percentage // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ProductionByStatusImpl implements _ProductionByStatus {
  const _$ProductionByStatusImpl(
      {required this.status, required this.count, required this.percentage});

  factory _$ProductionByStatusImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProductionByStatusImplFromJson(json);

  @override
  final String status;
  @override
  final int count;
  @override
  final double percentage;

  @override
  String toString() {
    return 'ProductionByStatus(status: $status, count: $count, percentage: $percentage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProductionByStatusImpl &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.count, count) || other.count == count) &&
            (identical(other.percentage, percentage) ||
                other.percentage == percentage));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, status, count, percentage);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ProductionByStatusImplCopyWith<_$ProductionByStatusImpl> get copyWith =>
      __$$ProductionByStatusImplCopyWithImpl<_$ProductionByStatusImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProductionByStatusImplToJson(
      this,
    );
  }
}

abstract class _ProductionByStatus implements ProductionByStatus {
  const factory _ProductionByStatus(
      {required final String status,
      required final int count,
      required final double percentage}) = _$ProductionByStatusImpl;

  factory _ProductionByStatus.fromJson(Map<String, dynamic> json) =
      _$ProductionByStatusImpl.fromJson;

  @override
  String get status;
  @override
  int get count;
  @override
  double get percentage;
  @override
  @JsonKey(ignore: true)
  _$$ProductionByStatusImplCopyWith<_$ProductionByStatusImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

EmployeeProduction _$EmployeeProductionFromJson(Map<String, dynamic> json) {
  return _EmployeeProduction.fromJson(json);
}

/// @nodoc
mixin _$EmployeeProduction {
  String get employeeId => throw _privateConstructorUsedError;
  String get employeeName => throw _privateConstructorUsedError;
  String get department => throw _privateConstructorUsedError;
  int get totalPcs => throw _privateConstructorUsedError;
  List<ProductionItem> get items => throw _privateConstructorUsedError;
  double get totalEarnings => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $EmployeeProductionCopyWith<EmployeeProduction> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EmployeeProductionCopyWith<$Res> {
  factory $EmployeeProductionCopyWith(
          EmployeeProduction value, $Res Function(EmployeeProduction) then) =
      _$EmployeeProductionCopyWithImpl<$Res, EmployeeProduction>;
  @useResult
  $Res call(
      {String employeeId,
      String employeeName,
      String department,
      int totalPcs,
      List<ProductionItem> items,
      double totalEarnings});
}

/// @nodoc
class _$EmployeeProductionCopyWithImpl<$Res, $Val extends EmployeeProduction>
    implements $EmployeeProductionCopyWith<$Res> {
  _$EmployeeProductionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? employeeId = null,
    Object? employeeName = null,
    Object? department = null,
    Object? totalPcs = null,
    Object? items = null,
    Object? totalEarnings = null,
  }) {
    return _then(_value.copyWith(
      employeeId: null == employeeId
          ? _value.employeeId
          : employeeId // ignore: cast_nullable_to_non_nullable
              as String,
      employeeName: null == employeeName
          ? _value.employeeName
          : employeeName // ignore: cast_nullable_to_non_nullable
              as String,
      department: null == department
          ? _value.department
          : department // ignore: cast_nullable_to_non_nullable
              as String,
      totalPcs: null == totalPcs
          ? _value.totalPcs
          : totalPcs // ignore: cast_nullable_to_non_nullable
              as int,
      items: null == items
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<ProductionItem>,
      totalEarnings: null == totalEarnings
          ? _value.totalEarnings
          : totalEarnings // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$EmployeeProductionImplCopyWith<$Res>
    implements $EmployeeProductionCopyWith<$Res> {
  factory _$$EmployeeProductionImplCopyWith(_$EmployeeProductionImpl value,
          $Res Function(_$EmployeeProductionImpl) then) =
      __$$EmployeeProductionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String employeeId,
      String employeeName,
      String department,
      int totalPcs,
      List<ProductionItem> items,
      double totalEarnings});
}

/// @nodoc
class __$$EmployeeProductionImplCopyWithImpl<$Res>
    extends _$EmployeeProductionCopyWithImpl<$Res, _$EmployeeProductionImpl>
    implements _$$EmployeeProductionImplCopyWith<$Res> {
  __$$EmployeeProductionImplCopyWithImpl(_$EmployeeProductionImpl _value,
      $Res Function(_$EmployeeProductionImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? employeeId = null,
    Object? employeeName = null,
    Object? department = null,
    Object? totalPcs = null,
    Object? items = null,
    Object? totalEarnings = null,
  }) {
    return _then(_$EmployeeProductionImpl(
      employeeId: null == employeeId
          ? _value.employeeId
          : employeeId // ignore: cast_nullable_to_non_nullable
              as String,
      employeeName: null == employeeName
          ? _value.employeeName
          : employeeName // ignore: cast_nullable_to_non_nullable
              as String,
      department: null == department
          ? _value.department
          : department // ignore: cast_nullable_to_non_nullable
              as String,
      totalPcs: null == totalPcs
          ? _value.totalPcs
          : totalPcs // ignore: cast_nullable_to_non_nullable
              as int,
      items: null == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<ProductionItem>,
      totalEarnings: null == totalEarnings
          ? _value.totalEarnings
          : totalEarnings // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$EmployeeProductionImpl implements _EmployeeProduction {
  const _$EmployeeProductionImpl(
      {required this.employeeId,
      required this.employeeName,
      required this.department,
      required this.totalPcs,
      required final List<ProductionItem> items,
      required this.totalEarnings})
      : _items = items;

  factory _$EmployeeProductionImpl.fromJson(Map<String, dynamic> json) =>
      _$$EmployeeProductionImplFromJson(json);

  @override
  final String employeeId;
  @override
  final String employeeName;
  @override
  final String department;
  @override
  final int totalPcs;
  final List<ProductionItem> _items;
  @override
  List<ProductionItem> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  final double totalEarnings;

  @override
  String toString() {
    return 'EmployeeProduction(employeeId: $employeeId, employeeName: $employeeName, department: $department, totalPcs: $totalPcs, items: $items, totalEarnings: $totalEarnings)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EmployeeProductionImpl &&
            (identical(other.employeeId, employeeId) ||
                other.employeeId == employeeId) &&
            (identical(other.employeeName, employeeName) ||
                other.employeeName == employeeName) &&
            (identical(other.department, department) ||
                other.department == department) &&
            (identical(other.totalPcs, totalPcs) ||
                other.totalPcs == totalPcs) &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.totalEarnings, totalEarnings) ||
                other.totalEarnings == totalEarnings));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      employeeId,
      employeeName,
      department,
      totalPcs,
      const DeepCollectionEquality().hash(_items),
      totalEarnings);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$EmployeeProductionImplCopyWith<_$EmployeeProductionImpl> get copyWith =>
      __$$EmployeeProductionImplCopyWithImpl<_$EmployeeProductionImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EmployeeProductionImplToJson(
      this,
    );
  }
}

abstract class _EmployeeProduction implements EmployeeProduction {
  const factory _EmployeeProduction(
      {required final String employeeId,
      required final String employeeName,
      required final String department,
      required final int totalPcs,
      required final List<ProductionItem> items,
      required final double totalEarnings}) = _$EmployeeProductionImpl;

  factory _EmployeeProduction.fromJson(Map<String, dynamic> json) =
      _$EmployeeProductionImpl.fromJson;

  @override
  String get employeeId;
  @override
  String get employeeName;
  @override
  String get department;
  @override
  int get totalPcs;
  @override
  List<ProductionItem> get items;
  @override
  double get totalEarnings;
  @override
  @JsonKey(ignore: true)
  _$$EmployeeProductionImplCopyWith<_$EmployeeProductionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ProductionItem _$ProductionItemFromJson(Map<String, dynamic> json) {
  return _ProductionItem.fromJson(json);
}

/// @nodoc
mixin _$ProductionItem {
  String get productName => throw _privateConstructorUsedError;
  String get department => throw _privateConstructorUsedError;
  int get pcs => throw _privateConstructorUsedError;
  double get ratePerPcs => throw _privateConstructorUsedError;
  double get earnings => throw _privateConstructorUsedError;
  String? get losin => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ProductionItemCopyWith<ProductionItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProductionItemCopyWith<$Res> {
  factory $ProductionItemCopyWith(
          ProductionItem value, $Res Function(ProductionItem) then) =
      _$ProductionItemCopyWithImpl<$Res, ProductionItem>;
  @useResult
  $Res call(
      {String productName,
      String department,
      int pcs,
      double ratePerPcs,
      double earnings,
      String? losin});
}

/// @nodoc
class _$ProductionItemCopyWithImpl<$Res, $Val extends ProductionItem>
    implements $ProductionItemCopyWith<$Res> {
  _$ProductionItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productName = null,
    Object? department = null,
    Object? pcs = null,
    Object? ratePerPcs = null,
    Object? earnings = null,
    Object? losin = freezed,
  }) {
    return _then(_value.copyWith(
      productName: null == productName
          ? _value.productName
          : productName // ignore: cast_nullable_to_non_nullable
              as String,
      department: null == department
          ? _value.department
          : department // ignore: cast_nullable_to_non_nullable
              as String,
      pcs: null == pcs
          ? _value.pcs
          : pcs // ignore: cast_nullable_to_non_nullable
              as int,
      ratePerPcs: null == ratePerPcs
          ? _value.ratePerPcs
          : ratePerPcs // ignore: cast_nullable_to_non_nullable
              as double,
      earnings: null == earnings
          ? _value.earnings
          : earnings // ignore: cast_nullable_to_non_nullable
              as double,
      losin: freezed == losin
          ? _value.losin
          : losin // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ProductionItemImplCopyWith<$Res>
    implements $ProductionItemCopyWith<$Res> {
  factory _$$ProductionItemImplCopyWith(_$ProductionItemImpl value,
          $Res Function(_$ProductionItemImpl) then) =
      __$$ProductionItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String productName,
      String department,
      int pcs,
      double ratePerPcs,
      double earnings,
      String? losin});
}

/// @nodoc
class __$$ProductionItemImplCopyWithImpl<$Res>
    extends _$ProductionItemCopyWithImpl<$Res, _$ProductionItemImpl>
    implements _$$ProductionItemImplCopyWith<$Res> {
  __$$ProductionItemImplCopyWithImpl(
      _$ProductionItemImpl _value, $Res Function(_$ProductionItemImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productName = null,
    Object? department = null,
    Object? pcs = null,
    Object? ratePerPcs = null,
    Object? earnings = null,
    Object? losin = freezed,
  }) {
    return _then(_$ProductionItemImpl(
      productName: null == productName
          ? _value.productName
          : productName // ignore: cast_nullable_to_non_nullable
              as String,
      department: null == department
          ? _value.department
          : department // ignore: cast_nullable_to_non_nullable
              as String,
      pcs: null == pcs
          ? _value.pcs
          : pcs // ignore: cast_nullable_to_non_nullable
              as int,
      ratePerPcs: null == ratePerPcs
          ? _value.ratePerPcs
          : ratePerPcs // ignore: cast_nullable_to_non_nullable
              as double,
      earnings: null == earnings
          ? _value.earnings
          : earnings // ignore: cast_nullable_to_non_nullable
              as double,
      losin: freezed == losin
          ? _value.losin
          : losin // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ProductionItemImpl implements _ProductionItem {
  const _$ProductionItemImpl(
      {required this.productName,
      required this.department,
      required this.pcs,
      required this.ratePerPcs,
      required this.earnings,
      required this.losin});

  factory _$ProductionItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProductionItemImplFromJson(json);

  @override
  final String productName;
  @override
  final String department;
  @override
  final int pcs;
  @override
  final double ratePerPcs;
  @override
  final double earnings;
  @override
  final String? losin;

  @override
  String toString() {
    return 'ProductionItem(productName: $productName, department: $department, pcs: $pcs, ratePerPcs: $ratePerPcs, earnings: $earnings, losin: $losin)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProductionItemImpl &&
            (identical(other.productName, productName) ||
                other.productName == productName) &&
            (identical(other.department, department) ||
                other.department == department) &&
            (identical(other.pcs, pcs) || other.pcs == pcs) &&
            (identical(other.ratePerPcs, ratePerPcs) ||
                other.ratePerPcs == ratePerPcs) &&
            (identical(other.earnings, earnings) ||
                other.earnings == earnings) &&
            (identical(other.losin, losin) || other.losin == losin));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, productName, department, pcs, ratePerPcs, earnings, losin);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ProductionItemImplCopyWith<_$ProductionItemImpl> get copyWith =>
      __$$ProductionItemImplCopyWithImpl<_$ProductionItemImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProductionItemImplToJson(
      this,
    );
  }
}

abstract class _ProductionItem implements ProductionItem {
  const factory _ProductionItem(
      {required final String productName,
      required final String department,
      required final int pcs,
      required final double ratePerPcs,
      required final double earnings,
      required final String? losin}) = _$ProductionItemImpl;

  factory _ProductionItem.fromJson(Map<String, dynamic> json) =
      _$ProductionItemImpl.fromJson;

  @override
  String get productName;
  @override
  String get department;
  @override
  int get pcs;
  @override
  double get ratePerPcs;
  @override
  double get earnings;
  @override
  String? get losin;
  @override
  @JsonKey(ignore: true)
  _$$ProductionItemImplCopyWith<_$ProductionItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
