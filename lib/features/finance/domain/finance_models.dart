import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

enum FinanceStatus { selesai, tertunda, sebagian }

class FinanceTransaction extends Equatable {
  const FinanceTransaction({
    required this.id,
    required this.userId,
    required this.type, // 'income' or 'expense'
    required this.category,
    required this.amount,
    required this.date,
    this.description,
    this.createdAt,
    this.account,
    this.note,
    this.status = FinanceStatus.selesai,
  });

  final String id;
  final String userId;
  final String type;
  final String category;
  final double amount;
  final DateTime date;
  final DateTime? createdAt;
  final String? description;
  final String? account;
  final String? note;
  final FinanceStatus status;

  bool get isIncome => type == 'income';
  bool get isExpense => type == 'expense';

  String get formattedAmount => NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  ).format(amount);

  String get dayLabel => DateFormat('dd MMM').format(date);
  String get timeLabel => DateFormat('dd MMM, HH:mm').format(createdAt ?? date);

  FinanceTransaction copyWith({
    String? id,
    String? userId,
    String? type,
    String? category,
    double? amount,
    DateTime? date,
    DateTime? createdAt,
    String? description,
    String? account,
    String? note,
    FinanceStatus? status,
  }) {
    return FinanceTransaction(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      category: category ?? this.category,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      createdAt: createdAt ?? this.createdAt,
      description: description ?? this.description,
      account: account ?? this.account,
      note: note ?? this.note,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    final desc = _composeDescription(
      account: account,
      note: note ?? description,
    );
    return {
      'id': id,
      'user_id': userId,
      'type': type,
      'category': category,
      'amount': amount,
      'description': desc,
      'date': DateFormat('yyyy-MM-dd').format(date),
      'created_at': createdAt?.toIso8601String(),
    };
  }

  factory FinanceTransaction.fromMap(Map<String, dynamic> map) {
    final rawDesc = map['description'] as String?;
    final parsedDesc = _parseDescription(rawDesc);
    final parsedStatus = _inferStatus(parsedDesc.note ?? rawDesc);
    return FinanceTransaction(
      id: map['id']?.toString() ?? '',
      userId: map['user_id']?.toString() ?? '',
      type: map['type']?.toString() ?? 'income',
      category: map['category']?.toString() ?? '-',
      amount: (map['amount'] as num?)?.toDouble() ?? 0,
      description: rawDesc,
      date: _parseDate(map['date']) ?? DateTime.now(),
      createdAt: _parseDate(map['created_at']),
      account: parsedDesc.account,
      note: parsedDesc.note,
      status: parsedStatus,
    );
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    final text = value.toString();
    if (text.isEmpty) return null;
    try {
      return DateTime.parse(text);
    } catch (_) {
      return null;
    }
  }

  static _DescriptionParts _parseDescription(String? description) {
    if (description == null || description.isEmpty) {
      return const _DescriptionParts();
    }
    if (description.startsWith('[') && description.contains(']')) {
      final end = description.indexOf(']');
      final account = description.substring(1, end).trim();
      final note = description.substring(end + 1).trim();
      return _DescriptionParts(
        account: account.isEmpty ? null : account,
        note: note.isEmpty ? null : note,
      );
    }
    return _DescriptionParts(note: description);
  }

  static String? _composeDescription({String? account, String? note}) {
    final trimmedAccount = account?.trim();
    final trimmedNote = note?.trim();
    if (trimmedAccount != null && trimmedAccount.isNotEmpty) {
      if (trimmedNote != null && trimmedNote.isNotEmpty) {
        return '[$trimmedAccount] $trimmedNote';
      }
      return '[$trimmedAccount]';
    }
    return trimmedNote;
  }

  static FinanceStatus _inferStatus(String? note) {
    final value = note?.toLowerCase() ?? '';
    if (value.contains('tunda') || value.contains('pending')) {
      return FinanceStatus.tertunda;
    }
    if (value.contains('sebagian') || value.contains('partial')) {
      return FinanceStatus.sebagian;
    }
    return FinanceStatus.selesai;
  }

  @override
  List<Object?> get props => [
    id,
    userId,
    type,
    category,
    amount,
    date,
    createdAt,
    description,
    account,
    note,
    status,
  ];
}

class FinanceSummary extends Equatable {
  const FinanceSummary({required this.income, required this.expense});

  final double income;
  final double expense;

  double get profit => income - expense;
  double get balance => profit;
  double get omzet => income;
  double get margin => income == 0 ? 0 : profit / income;

  static FinanceSummary fromTransactions(
    List<FinanceTransaction> txs, {
    DateTime? month,
  }) {
    final filtered = month == null
        ? txs
        : txs.where(
            (t) => t.date.year == month.year && t.date.month == month.month,
          );
    final income = filtered
        .where((t) => t.isIncome)
        .fold<double>(0, (p, e) => p + e.amount);
    final expense = filtered
        .where((t) => t.isExpense)
        .fold<double>(0, (p, e) => p + e.amount);
    return FinanceSummary(income: income, expense: expense);
  }

  @override
  List<Object?> get props => [income, expense];
}

class FinanceDailyPoint extends Equatable {
  const FinanceDailyPoint({
    required this.date,
    required this.income,
    required this.expense,
  });

  final DateTime date;
  final double income;
  final double expense;

  double get net => income - expense;

  @override
  List<Object?> get props => [date, income, expense];
}

class _DescriptionParts {
  const _DescriptionParts({this.account, this.note});
  final String? account;
  final String? note;
}
