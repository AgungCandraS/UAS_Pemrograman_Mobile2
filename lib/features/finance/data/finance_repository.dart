import 'dart:async';

import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:bisnisku/services/supabase_service.dart';
import '../domain/finance_models.dart';

class AuthExpiredException implements Exception {
  const AuthExpiredException([
    this.message = 'Sesi berakhir, silakan login ulang.',
  ]);
  final String message;

  @override
  String toString() => message;
}

class FinanceRepository {
  FinanceRepository({SupabaseClient? client})
    : _client = client ?? SupabaseService.instance.client;

  final SupabaseClient _client;

  static const _table = 'transactions';

  Future<List<FinanceTransaction>> fetchTransactions({
    DateTime? from,
    DateTime? to,
    int? limit,
  }) async {
    final uid = SupabaseService.instance.currentUser?.id;
    if (uid == null) return [];
    try {
      dynamic query = _client.from(_table).select().eq('user_id', uid);

      if (from != null) {
        query = query.gte('date', DateFormat('yyyy-MM-dd').format(from));
      }
      if (to != null) {
        query = query.lte('date', DateFormat('yyyy-MM-dd').format(to));
      }
      if (limit != null) query = query.limit(limit);

      final result = await query
          .order('date', ascending: false)
          .order('created_at', ascending: false);
      return _mapList(result);
    } on PostgrestException catch (e) {
      if (e.code == 'PGRST303') {
        throw const AuthExpiredException();
      }
      rethrow;
    }
  }

  Stream<List<FinanceTransaction>> watchTransactions({int limit = 120}) {
    final uid = SupabaseService.instance.currentUser?.id;
    if (uid == null) {
      return Stream.value(const <FinanceTransaction>[]);
    }
    final stream = _client
        .from(_table)
        .stream(primaryKey: ['id'])
        .eq('user_id', uid)
        .order('date', ascending: false)
        .order('created_at', ascending: false)
        .limit(limit);

    return stream.map(_mapList);
  }

  Future<FinanceSummary> fetchMonthlySummary(DateTime month) async {
    final start = DateTime(month.year, month.month, 1);
    final end = DateTime(month.year, month.month + 1, 0);
    final txs = await fetchTransactions(from: start, to: end, limit: 200);
    return FinanceSummary.fromTransactions(txs, month: month);
  }

  Future<FinanceTransaction?> addTransaction({
    required String type,
    required String category,
    required double amount,
    String? note,
    String? account,
    DateTime? date,
  }) async {
    final uid = SupabaseService.instance.currentUser?.id;
    if (uid == null) return null;
    final now = DateTime.now();
    final payload = {
      'user_id': uid,
      'type': type,
      'category': category,
      'amount': amount,
      'description': _composeDescription(account: account, note: note),
      'date': DateFormat('yyyy-MM-dd').format(date ?? now),
    };
    try {
      final Map<String, dynamic> inserted = await _client
          .from(_table)
          .insert(payload)
          .select()
          .single();
      return FinanceTransaction.fromMap(inserted);
    } on PostgrestException catch (e) {
      if (e.code == 'PGRST303') {
        throw const AuthExpiredException();
      }
      rethrow;
    }
  }

  Future<void> deleteTransaction(String id) async {
    final uid = SupabaseService.instance.currentUser?.id;
    if (uid == null) return;
    await _client.from(_table).delete().eq('id', id).eq('user_id', uid);
  }

  List<FinanceTransaction> _mapList(dynamic result) {
    if (result == null) return const [];
    return (result as List<dynamic>)
        .map((e) => FinanceTransaction.fromMap(e as Map<String, dynamic>))
        .toList();
  }

  String? _composeDescription({String? account, String? note}) {
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
}
