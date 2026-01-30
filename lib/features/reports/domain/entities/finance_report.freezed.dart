// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'finance_report.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

FinanceReport _$FinanceReportFromJson(Map<String, dynamic> json) {
  return _FinanceReport.fromJson(json);
}

/// @nodoc
mixin _$FinanceReport {
  String get id => throw _privateConstructorUsedError;
  DateTime get startDate => throw _privateConstructorUsedError;
  DateTime get endDate => throw _privateConstructorUsedError;
  double get totalIncome => throw _privateConstructorUsedError;
  double get totalExpense => throw _privateConstructorUsedError;
  double get netBalance => throw _privateConstructorUsedError;
  List<IncomeCategory> get incomeCategories =>
      throw _privateConstructorUsedError;
  List<ExpenseCategory> get expenseCategories =>
      throw _privateConstructorUsedError;
  List<DailyBalance> get dailyBalance => throw _privateConstructorUsedError;
  DateTime get generatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $FinanceReportCopyWith<FinanceReport> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FinanceReportCopyWith<$Res> {
  factory $FinanceReportCopyWith(
          FinanceReport value, $Res Function(FinanceReport) then) =
      _$FinanceReportCopyWithImpl<$Res, FinanceReport>;
  @useResult
  $Res call(
      {String id,
      DateTime startDate,
      DateTime endDate,
      double totalIncome,
      double totalExpense,
      double netBalance,
      List<IncomeCategory> incomeCategories,
      List<ExpenseCategory> expenseCategories,
      List<DailyBalance> dailyBalance,
      DateTime generatedAt});
}

/// @nodoc
class _$FinanceReportCopyWithImpl<$Res, $Val extends FinanceReport>
    implements $FinanceReportCopyWith<$Res> {
  _$FinanceReportCopyWithImpl(this._value, this._then);

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
    Object? totalIncome = null,
    Object? totalExpense = null,
    Object? netBalance = null,
    Object? incomeCategories = null,
    Object? expenseCategories = null,
    Object? dailyBalance = null,
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
      totalIncome: null == totalIncome
          ? _value.totalIncome
          : totalIncome // ignore: cast_nullable_to_non_nullable
              as double,
      totalExpense: null == totalExpense
          ? _value.totalExpense
          : totalExpense // ignore: cast_nullable_to_non_nullable
              as double,
      netBalance: null == netBalance
          ? _value.netBalance
          : netBalance // ignore: cast_nullable_to_non_nullable
              as double,
      incomeCategories: null == incomeCategories
          ? _value.incomeCategories
          : incomeCategories // ignore: cast_nullable_to_non_nullable
              as List<IncomeCategory>,
      expenseCategories: null == expenseCategories
          ? _value.expenseCategories
          : expenseCategories // ignore: cast_nullable_to_non_nullable
              as List<ExpenseCategory>,
      dailyBalance: null == dailyBalance
          ? _value.dailyBalance
          : dailyBalance // ignore: cast_nullable_to_non_nullable
              as List<DailyBalance>,
      generatedAt: null == generatedAt
          ? _value.generatedAt
          : generatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FinanceReportImplCopyWith<$Res>
    implements $FinanceReportCopyWith<$Res> {
  factory _$$FinanceReportImplCopyWith(
          _$FinanceReportImpl value, $Res Function(_$FinanceReportImpl) then) =
      __$$FinanceReportImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      DateTime startDate,
      DateTime endDate,
      double totalIncome,
      double totalExpense,
      double netBalance,
      List<IncomeCategory> incomeCategories,
      List<ExpenseCategory> expenseCategories,
      List<DailyBalance> dailyBalance,
      DateTime generatedAt});
}

/// @nodoc
class __$$FinanceReportImplCopyWithImpl<$Res>
    extends _$FinanceReportCopyWithImpl<$Res, _$FinanceReportImpl>
    implements _$$FinanceReportImplCopyWith<$Res> {
  __$$FinanceReportImplCopyWithImpl(
      _$FinanceReportImpl _value, $Res Function(_$FinanceReportImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? startDate = null,
    Object? endDate = null,
    Object? totalIncome = null,
    Object? totalExpense = null,
    Object? netBalance = null,
    Object? incomeCategories = null,
    Object? expenseCategories = null,
    Object? dailyBalance = null,
    Object? generatedAt = null,
  }) {
    return _then(_$FinanceReportImpl(
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
      totalIncome: null == totalIncome
          ? _value.totalIncome
          : totalIncome // ignore: cast_nullable_to_non_nullable
              as double,
      totalExpense: null == totalExpense
          ? _value.totalExpense
          : totalExpense // ignore: cast_nullable_to_non_nullable
              as double,
      netBalance: null == netBalance
          ? _value.netBalance
          : netBalance // ignore: cast_nullable_to_non_nullable
              as double,
      incomeCategories: null == incomeCategories
          ? _value._incomeCategories
          : incomeCategories // ignore: cast_nullable_to_non_nullable
              as List<IncomeCategory>,
      expenseCategories: null == expenseCategories
          ? _value._expenseCategories
          : expenseCategories // ignore: cast_nullable_to_non_nullable
              as List<ExpenseCategory>,
      dailyBalance: null == dailyBalance
          ? _value._dailyBalance
          : dailyBalance // ignore: cast_nullable_to_non_nullable
              as List<DailyBalance>,
      generatedAt: null == generatedAt
          ? _value.generatedAt
          : generatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FinanceReportImpl implements _FinanceReport {
  const _$FinanceReportImpl(
      {required this.id,
      required this.startDate,
      required this.endDate,
      required this.totalIncome,
      required this.totalExpense,
      required this.netBalance,
      required final List<IncomeCategory> incomeCategories,
      required final List<ExpenseCategory> expenseCategories,
      required final List<DailyBalance> dailyBalance,
      required this.generatedAt})
      : _incomeCategories = incomeCategories,
        _expenseCategories = expenseCategories,
        _dailyBalance = dailyBalance;

  factory _$FinanceReportImpl.fromJson(Map<String, dynamic> json) =>
      _$$FinanceReportImplFromJson(json);

  @override
  final String id;
  @override
  final DateTime startDate;
  @override
  final DateTime endDate;
  @override
  final double totalIncome;
  @override
  final double totalExpense;
  @override
  final double netBalance;
  final List<IncomeCategory> _incomeCategories;
  @override
  List<IncomeCategory> get incomeCategories {
    if (_incomeCategories is EqualUnmodifiableListView)
      return _incomeCategories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_incomeCategories);
  }

  final List<ExpenseCategory> _expenseCategories;
  @override
  List<ExpenseCategory> get expenseCategories {
    if (_expenseCategories is EqualUnmodifiableListView)
      return _expenseCategories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_expenseCategories);
  }

  final List<DailyBalance> _dailyBalance;
  @override
  List<DailyBalance> get dailyBalance {
    if (_dailyBalance is EqualUnmodifiableListView) return _dailyBalance;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_dailyBalance);
  }

  @override
  final DateTime generatedAt;

  @override
  String toString() {
    return 'FinanceReport(id: $id, startDate: $startDate, endDate: $endDate, totalIncome: $totalIncome, totalExpense: $totalExpense, netBalance: $netBalance, incomeCategories: $incomeCategories, expenseCategories: $expenseCategories, dailyBalance: $dailyBalance, generatedAt: $generatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FinanceReportImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.totalIncome, totalIncome) ||
                other.totalIncome == totalIncome) &&
            (identical(other.totalExpense, totalExpense) ||
                other.totalExpense == totalExpense) &&
            (identical(other.netBalance, netBalance) ||
                other.netBalance == netBalance) &&
            const DeepCollectionEquality()
                .equals(other._incomeCategories, _incomeCategories) &&
            const DeepCollectionEquality()
                .equals(other._expenseCategories, _expenseCategories) &&
            const DeepCollectionEquality()
                .equals(other._dailyBalance, _dailyBalance) &&
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
      totalIncome,
      totalExpense,
      netBalance,
      const DeepCollectionEquality().hash(_incomeCategories),
      const DeepCollectionEquality().hash(_expenseCategories),
      const DeepCollectionEquality().hash(_dailyBalance),
      generatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$FinanceReportImplCopyWith<_$FinanceReportImpl> get copyWith =>
      __$$FinanceReportImplCopyWithImpl<_$FinanceReportImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FinanceReportImplToJson(
      this,
    );
  }
}

abstract class _FinanceReport implements FinanceReport {
  const factory _FinanceReport(
      {required final String id,
      required final DateTime startDate,
      required final DateTime endDate,
      required final double totalIncome,
      required final double totalExpense,
      required final double netBalance,
      required final List<IncomeCategory> incomeCategories,
      required final List<ExpenseCategory> expenseCategories,
      required final List<DailyBalance> dailyBalance,
      required final DateTime generatedAt}) = _$FinanceReportImpl;

  factory _FinanceReport.fromJson(Map<String, dynamic> json) =
      _$FinanceReportImpl.fromJson;

  @override
  String get id;
  @override
  DateTime get startDate;
  @override
  DateTime get endDate;
  @override
  double get totalIncome;
  @override
  double get totalExpense;
  @override
  double get netBalance;
  @override
  List<IncomeCategory> get incomeCategories;
  @override
  List<ExpenseCategory> get expenseCategories;
  @override
  List<DailyBalance> get dailyBalance;
  @override
  DateTime get generatedAt;
  @override
  @JsonKey(ignore: true)
  _$$FinanceReportImplCopyWith<_$FinanceReportImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

IncomeCategory _$IncomeCategoryFromJson(Map<String, dynamic> json) {
  return _IncomeCategory.fromJson(json);
}

/// @nodoc
mixin _$IncomeCategory {
  String get name => throw _privateConstructorUsedError;
  double get amount => throw _privateConstructorUsedError;
  double get percentage => throw _privateConstructorUsedError;
  int get transactionCount => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $IncomeCategoryCopyWith<IncomeCategory> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $IncomeCategoryCopyWith<$Res> {
  factory $IncomeCategoryCopyWith(
          IncomeCategory value, $Res Function(IncomeCategory) then) =
      _$IncomeCategoryCopyWithImpl<$Res, IncomeCategory>;
  @useResult
  $Res call(
      {String name, double amount, double percentage, int transactionCount});
}

/// @nodoc
class _$IncomeCategoryCopyWithImpl<$Res, $Val extends IncomeCategory>
    implements $IncomeCategoryCopyWith<$Res> {
  _$IncomeCategoryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? amount = null,
    Object? percentage = null,
    Object? transactionCount = null,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      percentage: null == percentage
          ? _value.percentage
          : percentage // ignore: cast_nullable_to_non_nullable
              as double,
      transactionCount: null == transactionCount
          ? _value.transactionCount
          : transactionCount // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$IncomeCategoryImplCopyWith<$Res>
    implements $IncomeCategoryCopyWith<$Res> {
  factory _$$IncomeCategoryImplCopyWith(_$IncomeCategoryImpl value,
          $Res Function(_$IncomeCategoryImpl) then) =
      __$$IncomeCategoryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String name, double amount, double percentage, int transactionCount});
}

/// @nodoc
class __$$IncomeCategoryImplCopyWithImpl<$Res>
    extends _$IncomeCategoryCopyWithImpl<$Res, _$IncomeCategoryImpl>
    implements _$$IncomeCategoryImplCopyWith<$Res> {
  __$$IncomeCategoryImplCopyWithImpl(
      _$IncomeCategoryImpl _value, $Res Function(_$IncomeCategoryImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? amount = null,
    Object? percentage = null,
    Object? transactionCount = null,
  }) {
    return _then(_$IncomeCategoryImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      percentage: null == percentage
          ? _value.percentage
          : percentage // ignore: cast_nullable_to_non_nullable
              as double,
      transactionCount: null == transactionCount
          ? _value.transactionCount
          : transactionCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$IncomeCategoryImpl implements _IncomeCategory {
  const _$IncomeCategoryImpl(
      {required this.name,
      required this.amount,
      required this.percentage,
      required this.transactionCount});

  factory _$IncomeCategoryImpl.fromJson(Map<String, dynamic> json) =>
      _$$IncomeCategoryImplFromJson(json);

  @override
  final String name;
  @override
  final double amount;
  @override
  final double percentage;
  @override
  final int transactionCount;

  @override
  String toString() {
    return 'IncomeCategory(name: $name, amount: $amount, percentage: $percentage, transactionCount: $transactionCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$IncomeCategoryImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.percentage, percentage) ||
                other.percentage == percentage) &&
            (identical(other.transactionCount, transactionCount) ||
                other.transactionCount == transactionCount));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, name, amount, percentage, transactionCount);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$IncomeCategoryImplCopyWith<_$IncomeCategoryImpl> get copyWith =>
      __$$IncomeCategoryImplCopyWithImpl<_$IncomeCategoryImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$IncomeCategoryImplToJson(
      this,
    );
  }
}

abstract class _IncomeCategory implements IncomeCategory {
  const factory _IncomeCategory(
      {required final String name,
      required final double amount,
      required final double percentage,
      required final int transactionCount}) = _$IncomeCategoryImpl;

  factory _IncomeCategory.fromJson(Map<String, dynamic> json) =
      _$IncomeCategoryImpl.fromJson;

  @override
  String get name;
  @override
  double get amount;
  @override
  double get percentage;
  @override
  int get transactionCount;
  @override
  @JsonKey(ignore: true)
  _$$IncomeCategoryImplCopyWith<_$IncomeCategoryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ExpenseCategory _$ExpenseCategoryFromJson(Map<String, dynamic> json) {
  return _ExpenseCategory.fromJson(json);
}

/// @nodoc
mixin _$ExpenseCategory {
  String get name => throw _privateConstructorUsedError;
  double get amount => throw _privateConstructorUsedError;
  double get percentage => throw _privateConstructorUsedError;
  int get transactionCount => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ExpenseCategoryCopyWith<ExpenseCategory> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExpenseCategoryCopyWith<$Res> {
  factory $ExpenseCategoryCopyWith(
          ExpenseCategory value, $Res Function(ExpenseCategory) then) =
      _$ExpenseCategoryCopyWithImpl<$Res, ExpenseCategory>;
  @useResult
  $Res call(
      {String name, double amount, double percentage, int transactionCount});
}

/// @nodoc
class _$ExpenseCategoryCopyWithImpl<$Res, $Val extends ExpenseCategory>
    implements $ExpenseCategoryCopyWith<$Res> {
  _$ExpenseCategoryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? amount = null,
    Object? percentage = null,
    Object? transactionCount = null,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      percentage: null == percentage
          ? _value.percentage
          : percentage // ignore: cast_nullable_to_non_nullable
              as double,
      transactionCount: null == transactionCount
          ? _value.transactionCount
          : transactionCount // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ExpenseCategoryImplCopyWith<$Res>
    implements $ExpenseCategoryCopyWith<$Res> {
  factory _$$ExpenseCategoryImplCopyWith(_$ExpenseCategoryImpl value,
          $Res Function(_$ExpenseCategoryImpl) then) =
      __$$ExpenseCategoryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String name, double amount, double percentage, int transactionCount});
}

/// @nodoc
class __$$ExpenseCategoryImplCopyWithImpl<$Res>
    extends _$ExpenseCategoryCopyWithImpl<$Res, _$ExpenseCategoryImpl>
    implements _$$ExpenseCategoryImplCopyWith<$Res> {
  __$$ExpenseCategoryImplCopyWithImpl(
      _$ExpenseCategoryImpl _value, $Res Function(_$ExpenseCategoryImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? amount = null,
    Object? percentage = null,
    Object? transactionCount = null,
  }) {
    return _then(_$ExpenseCategoryImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      percentage: null == percentage
          ? _value.percentage
          : percentage // ignore: cast_nullable_to_non_nullable
              as double,
      transactionCount: null == transactionCount
          ? _value.transactionCount
          : transactionCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ExpenseCategoryImpl implements _ExpenseCategory {
  const _$ExpenseCategoryImpl(
      {required this.name,
      required this.amount,
      required this.percentage,
      required this.transactionCount});

  factory _$ExpenseCategoryImpl.fromJson(Map<String, dynamic> json) =>
      _$$ExpenseCategoryImplFromJson(json);

  @override
  final String name;
  @override
  final double amount;
  @override
  final double percentage;
  @override
  final int transactionCount;

  @override
  String toString() {
    return 'ExpenseCategory(name: $name, amount: $amount, percentage: $percentage, transactionCount: $transactionCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExpenseCategoryImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.percentage, percentage) ||
                other.percentage == percentage) &&
            (identical(other.transactionCount, transactionCount) ||
                other.transactionCount == transactionCount));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, name, amount, percentage, transactionCount);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ExpenseCategoryImplCopyWith<_$ExpenseCategoryImpl> get copyWith =>
      __$$ExpenseCategoryImplCopyWithImpl<_$ExpenseCategoryImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ExpenseCategoryImplToJson(
      this,
    );
  }
}

abstract class _ExpenseCategory implements ExpenseCategory {
  const factory _ExpenseCategory(
      {required final String name,
      required final double amount,
      required final double percentage,
      required final int transactionCount}) = _$ExpenseCategoryImpl;

  factory _ExpenseCategory.fromJson(Map<String, dynamic> json) =
      _$ExpenseCategoryImpl.fromJson;

  @override
  String get name;
  @override
  double get amount;
  @override
  double get percentage;
  @override
  int get transactionCount;
  @override
  @JsonKey(ignore: true)
  _$$ExpenseCategoryImplCopyWith<_$ExpenseCategoryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DailyBalance _$DailyBalanceFromJson(Map<String, dynamic> json) {
  return _DailyBalance.fromJson(json);
}

/// @nodoc
mixin _$DailyBalance {
  DateTime get date => throw _privateConstructorUsedError;
  double get income => throw _privateConstructorUsedError;
  double get expense => throw _privateConstructorUsedError;
  double get balance => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $DailyBalanceCopyWith<DailyBalance> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DailyBalanceCopyWith<$Res> {
  factory $DailyBalanceCopyWith(
          DailyBalance value, $Res Function(DailyBalance) then) =
      _$DailyBalanceCopyWithImpl<$Res, DailyBalance>;
  @useResult
  $Res call({DateTime date, double income, double expense, double balance});
}

/// @nodoc
class _$DailyBalanceCopyWithImpl<$Res, $Val extends DailyBalance>
    implements $DailyBalanceCopyWith<$Res> {
  _$DailyBalanceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? income = null,
    Object? expense = null,
    Object? balance = null,
  }) {
    return _then(_value.copyWith(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      income: null == income
          ? _value.income
          : income // ignore: cast_nullable_to_non_nullable
              as double,
      expense: null == expense
          ? _value.expense
          : expense // ignore: cast_nullable_to_non_nullable
              as double,
      balance: null == balance
          ? _value.balance
          : balance // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DailyBalanceImplCopyWith<$Res>
    implements $DailyBalanceCopyWith<$Res> {
  factory _$$DailyBalanceImplCopyWith(
          _$DailyBalanceImpl value, $Res Function(_$DailyBalanceImpl) then) =
      __$$DailyBalanceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({DateTime date, double income, double expense, double balance});
}

/// @nodoc
class __$$DailyBalanceImplCopyWithImpl<$Res>
    extends _$DailyBalanceCopyWithImpl<$Res, _$DailyBalanceImpl>
    implements _$$DailyBalanceImplCopyWith<$Res> {
  __$$DailyBalanceImplCopyWithImpl(
      _$DailyBalanceImpl _value, $Res Function(_$DailyBalanceImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? income = null,
    Object? expense = null,
    Object? balance = null,
  }) {
    return _then(_$DailyBalanceImpl(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      income: null == income
          ? _value.income
          : income // ignore: cast_nullable_to_non_nullable
              as double,
      expense: null == expense
          ? _value.expense
          : expense // ignore: cast_nullable_to_non_nullable
              as double,
      balance: null == balance
          ? _value.balance
          : balance // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DailyBalanceImpl implements _DailyBalance {
  const _$DailyBalanceImpl(
      {required this.date,
      required this.income,
      required this.expense,
      required this.balance});

  factory _$DailyBalanceImpl.fromJson(Map<String, dynamic> json) =>
      _$$DailyBalanceImplFromJson(json);

  @override
  final DateTime date;
  @override
  final double income;
  @override
  final double expense;
  @override
  final double balance;

  @override
  String toString() {
    return 'DailyBalance(date: $date, income: $income, expense: $expense, balance: $balance)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DailyBalanceImpl &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.income, income) || other.income == income) &&
            (identical(other.expense, expense) || other.expense == expense) &&
            (identical(other.balance, balance) || other.balance == balance));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, date, income, expense, balance);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DailyBalanceImplCopyWith<_$DailyBalanceImpl> get copyWith =>
      __$$DailyBalanceImplCopyWithImpl<_$DailyBalanceImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DailyBalanceImplToJson(
      this,
    );
  }
}

abstract class _DailyBalance implements DailyBalance {
  const factory _DailyBalance(
      {required final DateTime date,
      required final double income,
      required final double expense,
      required final double balance}) = _$DailyBalanceImpl;

  factory _DailyBalance.fromJson(Map<String, dynamic> json) =
      _$DailyBalanceImpl.fromJson;

  @override
  DateTime get date;
  @override
  double get income;
  @override
  double get expense;
  @override
  double get balance;
  @override
  @JsonKey(ignore: true)
  _$$DailyBalanceImplCopyWith<_$DailyBalanceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
