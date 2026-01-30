// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'payroll_report.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PayrollReport _$PayrollReportFromJson(Map<String, dynamic> json) {
  return _PayrollReport.fromJson(json);
}

/// @nodoc
mixin _$PayrollReport {
  String get id => throw _privateConstructorUsedError;
  DateTime get startDate => throw _privateConstructorUsedError;
  DateTime get endDate => throw _privateConstructorUsedError;
  double get totalGrossSalary => throw _privateConstructorUsedError;
  double get totalTax => throw _privateConstructorUsedError;
  double get totalNetSalary => throw _privateConstructorUsedError;
  double get totalBonus => throw _privateConstructorUsedError;
  double get totalDeduction => throw _privateConstructorUsedError;
  List<EmployeePayroll> get employeePayrolls =>
      throw _privateConstructorUsedError;
  int get totalEmployees => throw _privateConstructorUsedError;
  DateTime get generatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PayrollReportCopyWith<PayrollReport> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PayrollReportCopyWith<$Res> {
  factory $PayrollReportCopyWith(
          PayrollReport value, $Res Function(PayrollReport) then) =
      _$PayrollReportCopyWithImpl<$Res, PayrollReport>;
  @useResult
  $Res call(
      {String id,
      DateTime startDate,
      DateTime endDate,
      double totalGrossSalary,
      double totalTax,
      double totalNetSalary,
      double totalBonus,
      double totalDeduction,
      List<EmployeePayroll> employeePayrolls,
      int totalEmployees,
      DateTime generatedAt});
}

/// @nodoc
class _$PayrollReportCopyWithImpl<$Res, $Val extends PayrollReport>
    implements $PayrollReportCopyWith<$Res> {
  _$PayrollReportCopyWithImpl(this._value, this._then);

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
    Object? totalGrossSalary = null,
    Object? totalTax = null,
    Object? totalNetSalary = null,
    Object? totalBonus = null,
    Object? totalDeduction = null,
    Object? employeePayrolls = null,
    Object? totalEmployees = null,
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
      totalGrossSalary: null == totalGrossSalary
          ? _value.totalGrossSalary
          : totalGrossSalary // ignore: cast_nullable_to_non_nullable
              as double,
      totalTax: null == totalTax
          ? _value.totalTax
          : totalTax // ignore: cast_nullable_to_non_nullable
              as double,
      totalNetSalary: null == totalNetSalary
          ? _value.totalNetSalary
          : totalNetSalary // ignore: cast_nullable_to_non_nullable
              as double,
      totalBonus: null == totalBonus
          ? _value.totalBonus
          : totalBonus // ignore: cast_nullable_to_non_nullable
              as double,
      totalDeduction: null == totalDeduction
          ? _value.totalDeduction
          : totalDeduction // ignore: cast_nullable_to_non_nullable
              as double,
      employeePayrolls: null == employeePayrolls
          ? _value.employeePayrolls
          : employeePayrolls // ignore: cast_nullable_to_non_nullable
              as List<EmployeePayroll>,
      totalEmployees: null == totalEmployees
          ? _value.totalEmployees
          : totalEmployees // ignore: cast_nullable_to_non_nullable
              as int,
      generatedAt: null == generatedAt
          ? _value.generatedAt
          : generatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PayrollReportImplCopyWith<$Res>
    implements $PayrollReportCopyWith<$Res> {
  factory _$$PayrollReportImplCopyWith(
          _$PayrollReportImpl value, $Res Function(_$PayrollReportImpl) then) =
      __$$PayrollReportImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      DateTime startDate,
      DateTime endDate,
      double totalGrossSalary,
      double totalTax,
      double totalNetSalary,
      double totalBonus,
      double totalDeduction,
      List<EmployeePayroll> employeePayrolls,
      int totalEmployees,
      DateTime generatedAt});
}

/// @nodoc
class __$$PayrollReportImplCopyWithImpl<$Res>
    extends _$PayrollReportCopyWithImpl<$Res, _$PayrollReportImpl>
    implements _$$PayrollReportImplCopyWith<$Res> {
  __$$PayrollReportImplCopyWithImpl(
      _$PayrollReportImpl _value, $Res Function(_$PayrollReportImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? startDate = null,
    Object? endDate = null,
    Object? totalGrossSalary = null,
    Object? totalTax = null,
    Object? totalNetSalary = null,
    Object? totalBonus = null,
    Object? totalDeduction = null,
    Object? employeePayrolls = null,
    Object? totalEmployees = null,
    Object? generatedAt = null,
  }) {
    return _then(_$PayrollReportImpl(
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
      totalGrossSalary: null == totalGrossSalary
          ? _value.totalGrossSalary
          : totalGrossSalary // ignore: cast_nullable_to_non_nullable
              as double,
      totalTax: null == totalTax
          ? _value.totalTax
          : totalTax // ignore: cast_nullable_to_non_nullable
              as double,
      totalNetSalary: null == totalNetSalary
          ? _value.totalNetSalary
          : totalNetSalary // ignore: cast_nullable_to_non_nullable
              as double,
      totalBonus: null == totalBonus
          ? _value.totalBonus
          : totalBonus // ignore: cast_nullable_to_non_nullable
              as double,
      totalDeduction: null == totalDeduction
          ? _value.totalDeduction
          : totalDeduction // ignore: cast_nullable_to_non_nullable
              as double,
      employeePayrolls: null == employeePayrolls
          ? _value._employeePayrolls
          : employeePayrolls // ignore: cast_nullable_to_non_nullable
              as List<EmployeePayroll>,
      totalEmployees: null == totalEmployees
          ? _value.totalEmployees
          : totalEmployees // ignore: cast_nullable_to_non_nullable
              as int,
      generatedAt: null == generatedAt
          ? _value.generatedAt
          : generatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PayrollReportImpl implements _PayrollReport {
  const _$PayrollReportImpl(
      {required this.id,
      required this.startDate,
      required this.endDate,
      required this.totalGrossSalary,
      required this.totalTax,
      required this.totalNetSalary,
      required this.totalBonus,
      required this.totalDeduction,
      required final List<EmployeePayroll> employeePayrolls,
      required this.totalEmployees,
      required this.generatedAt})
      : _employeePayrolls = employeePayrolls;

  factory _$PayrollReportImpl.fromJson(Map<String, dynamic> json) =>
      _$$PayrollReportImplFromJson(json);

  @override
  final String id;
  @override
  final DateTime startDate;
  @override
  final DateTime endDate;
  @override
  final double totalGrossSalary;
  @override
  final double totalTax;
  @override
  final double totalNetSalary;
  @override
  final double totalBonus;
  @override
  final double totalDeduction;
  final List<EmployeePayroll> _employeePayrolls;
  @override
  List<EmployeePayroll> get employeePayrolls {
    if (_employeePayrolls is EqualUnmodifiableListView)
      return _employeePayrolls;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_employeePayrolls);
  }

  @override
  final int totalEmployees;
  @override
  final DateTime generatedAt;

  @override
  String toString() {
    return 'PayrollReport(id: $id, startDate: $startDate, endDate: $endDate, totalGrossSalary: $totalGrossSalary, totalTax: $totalTax, totalNetSalary: $totalNetSalary, totalBonus: $totalBonus, totalDeduction: $totalDeduction, employeePayrolls: $employeePayrolls, totalEmployees: $totalEmployees, generatedAt: $generatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PayrollReportImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.totalGrossSalary, totalGrossSalary) ||
                other.totalGrossSalary == totalGrossSalary) &&
            (identical(other.totalTax, totalTax) ||
                other.totalTax == totalTax) &&
            (identical(other.totalNetSalary, totalNetSalary) ||
                other.totalNetSalary == totalNetSalary) &&
            (identical(other.totalBonus, totalBonus) ||
                other.totalBonus == totalBonus) &&
            (identical(other.totalDeduction, totalDeduction) ||
                other.totalDeduction == totalDeduction) &&
            const DeepCollectionEquality()
                .equals(other._employeePayrolls, _employeePayrolls) &&
            (identical(other.totalEmployees, totalEmployees) ||
                other.totalEmployees == totalEmployees) &&
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
      totalGrossSalary,
      totalTax,
      totalNetSalary,
      totalBonus,
      totalDeduction,
      const DeepCollectionEquality().hash(_employeePayrolls),
      totalEmployees,
      generatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PayrollReportImplCopyWith<_$PayrollReportImpl> get copyWith =>
      __$$PayrollReportImplCopyWithImpl<_$PayrollReportImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PayrollReportImplToJson(
      this,
    );
  }
}

abstract class _PayrollReport implements PayrollReport {
  const factory _PayrollReport(
      {required final String id,
      required final DateTime startDate,
      required final DateTime endDate,
      required final double totalGrossSalary,
      required final double totalTax,
      required final double totalNetSalary,
      required final double totalBonus,
      required final double totalDeduction,
      required final List<EmployeePayroll> employeePayrolls,
      required final int totalEmployees,
      required final DateTime generatedAt}) = _$PayrollReportImpl;

  factory _PayrollReport.fromJson(Map<String, dynamic> json) =
      _$PayrollReportImpl.fromJson;

  @override
  String get id;
  @override
  DateTime get startDate;
  @override
  DateTime get endDate;
  @override
  double get totalGrossSalary;
  @override
  double get totalTax;
  @override
  double get totalNetSalary;
  @override
  double get totalBonus;
  @override
  double get totalDeduction;
  @override
  List<EmployeePayroll> get employeePayrolls;
  @override
  int get totalEmployees;
  @override
  DateTime get generatedAt;
  @override
  @JsonKey(ignore: true)
  _$$PayrollReportImplCopyWith<_$PayrollReportImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

EmployeePayroll _$EmployeePayrollFromJson(Map<String, dynamic> json) {
  return _EmployeePayroll.fromJson(json);
}

/// @nodoc
mixin _$EmployeePayroll {
  String get employeeId => throw _privateConstructorUsedError;
  String get employeeName => throw _privateConstructorUsedError;
  String get position => throw _privateConstructorUsedError;
  double get baseSalary => throw _privateConstructorUsedError;
  double get bonus => throw _privateConstructorUsedError;
  double get deduction => throw _privateConstructorUsedError;
  double get taxAmount => throw _privateConstructorUsedError;
  double get netSalary => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $EmployeePayrollCopyWith<EmployeePayroll> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EmployeePayrollCopyWith<$Res> {
  factory $EmployeePayrollCopyWith(
          EmployeePayroll value, $Res Function(EmployeePayroll) then) =
      _$EmployeePayrollCopyWithImpl<$Res, EmployeePayroll>;
  @useResult
  $Res call(
      {String employeeId,
      String employeeName,
      String position,
      double baseSalary,
      double bonus,
      double deduction,
      double taxAmount,
      double netSalary,
      String status});
}

/// @nodoc
class _$EmployeePayrollCopyWithImpl<$Res, $Val extends EmployeePayroll>
    implements $EmployeePayrollCopyWith<$Res> {
  _$EmployeePayrollCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? employeeId = null,
    Object? employeeName = null,
    Object? position = null,
    Object? baseSalary = null,
    Object? bonus = null,
    Object? deduction = null,
    Object? taxAmount = null,
    Object? netSalary = null,
    Object? status = null,
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
      position: null == position
          ? _value.position
          : position // ignore: cast_nullable_to_non_nullable
              as String,
      baseSalary: null == baseSalary
          ? _value.baseSalary
          : baseSalary // ignore: cast_nullable_to_non_nullable
              as double,
      bonus: null == bonus
          ? _value.bonus
          : bonus // ignore: cast_nullable_to_non_nullable
              as double,
      deduction: null == deduction
          ? _value.deduction
          : deduction // ignore: cast_nullable_to_non_nullable
              as double,
      taxAmount: null == taxAmount
          ? _value.taxAmount
          : taxAmount // ignore: cast_nullable_to_non_nullable
              as double,
      netSalary: null == netSalary
          ? _value.netSalary
          : netSalary // ignore: cast_nullable_to_non_nullable
              as double,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$EmployeePayrollImplCopyWith<$Res>
    implements $EmployeePayrollCopyWith<$Res> {
  factory _$$EmployeePayrollImplCopyWith(_$EmployeePayrollImpl value,
          $Res Function(_$EmployeePayrollImpl) then) =
      __$$EmployeePayrollImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String employeeId,
      String employeeName,
      String position,
      double baseSalary,
      double bonus,
      double deduction,
      double taxAmount,
      double netSalary,
      String status});
}

/// @nodoc
class __$$EmployeePayrollImplCopyWithImpl<$Res>
    extends _$EmployeePayrollCopyWithImpl<$Res, _$EmployeePayrollImpl>
    implements _$$EmployeePayrollImplCopyWith<$Res> {
  __$$EmployeePayrollImplCopyWithImpl(
      _$EmployeePayrollImpl _value, $Res Function(_$EmployeePayrollImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? employeeId = null,
    Object? employeeName = null,
    Object? position = null,
    Object? baseSalary = null,
    Object? bonus = null,
    Object? deduction = null,
    Object? taxAmount = null,
    Object? netSalary = null,
    Object? status = null,
  }) {
    return _then(_$EmployeePayrollImpl(
      employeeId: null == employeeId
          ? _value.employeeId
          : employeeId // ignore: cast_nullable_to_non_nullable
              as String,
      employeeName: null == employeeName
          ? _value.employeeName
          : employeeName // ignore: cast_nullable_to_non_nullable
              as String,
      position: null == position
          ? _value.position
          : position // ignore: cast_nullable_to_non_nullable
              as String,
      baseSalary: null == baseSalary
          ? _value.baseSalary
          : baseSalary // ignore: cast_nullable_to_non_nullable
              as double,
      bonus: null == bonus
          ? _value.bonus
          : bonus // ignore: cast_nullable_to_non_nullable
              as double,
      deduction: null == deduction
          ? _value.deduction
          : deduction // ignore: cast_nullable_to_non_nullable
              as double,
      taxAmount: null == taxAmount
          ? _value.taxAmount
          : taxAmount // ignore: cast_nullable_to_non_nullable
              as double,
      netSalary: null == netSalary
          ? _value.netSalary
          : netSalary // ignore: cast_nullable_to_non_nullable
              as double,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$EmployeePayrollImpl implements _EmployeePayroll {
  const _$EmployeePayrollImpl(
      {required this.employeeId,
      required this.employeeName,
      required this.position,
      required this.baseSalary,
      required this.bonus,
      required this.deduction,
      required this.taxAmount,
      required this.netSalary,
      required this.status});

  factory _$EmployeePayrollImpl.fromJson(Map<String, dynamic> json) =>
      _$$EmployeePayrollImplFromJson(json);

  @override
  final String employeeId;
  @override
  final String employeeName;
  @override
  final String position;
  @override
  final double baseSalary;
  @override
  final double bonus;
  @override
  final double deduction;
  @override
  final double taxAmount;
  @override
  final double netSalary;
  @override
  final String status;

  @override
  String toString() {
    return 'EmployeePayroll(employeeId: $employeeId, employeeName: $employeeName, position: $position, baseSalary: $baseSalary, bonus: $bonus, deduction: $deduction, taxAmount: $taxAmount, netSalary: $netSalary, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EmployeePayrollImpl &&
            (identical(other.employeeId, employeeId) ||
                other.employeeId == employeeId) &&
            (identical(other.employeeName, employeeName) ||
                other.employeeName == employeeName) &&
            (identical(other.position, position) ||
                other.position == position) &&
            (identical(other.baseSalary, baseSalary) ||
                other.baseSalary == baseSalary) &&
            (identical(other.bonus, bonus) || other.bonus == bonus) &&
            (identical(other.deduction, deduction) ||
                other.deduction == deduction) &&
            (identical(other.taxAmount, taxAmount) ||
                other.taxAmount == taxAmount) &&
            (identical(other.netSalary, netSalary) ||
                other.netSalary == netSalary) &&
            (identical(other.status, status) || other.status == status));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, employeeId, employeeName,
      position, baseSalary, bonus, deduction, taxAmount, netSalary, status);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$EmployeePayrollImplCopyWith<_$EmployeePayrollImpl> get copyWith =>
      __$$EmployeePayrollImplCopyWithImpl<_$EmployeePayrollImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EmployeePayrollImplToJson(
      this,
    );
  }
}

abstract class _EmployeePayroll implements EmployeePayroll {
  const factory _EmployeePayroll(
      {required final String employeeId,
      required final String employeeName,
      required final String position,
      required final double baseSalary,
      required final double bonus,
      required final double deduction,
      required final double taxAmount,
      required final double netSalary,
      required final String status}) = _$EmployeePayrollImpl;

  factory _EmployeePayroll.fromJson(Map<String, dynamic> json) =
      _$EmployeePayrollImpl.fromJson;

  @override
  String get employeeId;
  @override
  String get employeeName;
  @override
  String get position;
  @override
  double get baseSalary;
  @override
  double get bonus;
  @override
  double get deduction;
  @override
  double get taxAmount;
  @override
  double get netSalary;
  @override
  String get status;
  @override
  @JsonKey(ignore: true)
  _$$EmployeePayrollImplCopyWith<_$EmployeePayrollImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
