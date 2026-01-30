import 'package:intl/intl.dart';

/// Currency formatting utility
class CurrencyFormatter {
  /// Format amount dengan currency code
  static String format(double amount, {String currencyCode = 'IDR'}) {
    try {
      final formatter = NumberFormat.currency(
        locale: _getLocaleForCurrency(currencyCode),
        symbol: _getCurrencySymbol(currencyCode),
        decimalDigits: 0,
      );
      return formatter.format(amount);
    } catch (e) {
      return '${_getCurrencySymbol(currencyCode)} ${amount.toStringAsFixed(0)}';
    }
  }

  /// Format amount untuk display
  static String formatForDisplay(double amount, {String currencyCode = 'IDR'}) {
    return format(amount, currencyCode: currencyCode);
  }

  /// Parse string currency ke double
  static double parse(String value, {String currencyCode = 'IDR'}) {
    try {
      // Remove currency symbol and format characters
      String cleaned = value.replaceAll(RegExp(r'[^\d.]'), '');
      return double.parse(cleaned);
    } catch (e) {
      return 0.0;
    }
  }

  /// Get currency info
  static String getCurrencyInfo(String currencyCode) {
    const info = {
      'IDR': 'Indonesian Rupiah',
      'USD': 'US Dollar',
      'EUR': 'Euro',
      'SGD': 'Singapore Dollar',
      'MYR': 'Malaysian Ringgit',
      'PHP': 'Philippine Peso',
      'THB': 'Thai Baht',
      'GBP': 'British Pound',
      'JPY': 'Japanese Yen',
      'CNY': 'Chinese Yuan',
    };
    return info[currencyCode] ?? currencyCode;
  }

  /// Get currency symbol
  static String _getCurrencySymbol(String currencyCode) {
    const symbols = {
      'IDR': 'Rp',
      'USD': '\$',
      'EUR': '€',
      'SGD': 'S\$',
      'MYR': 'RM',
      'PHP': '₱',
      'THB': '฿',
      'GBP': '£',
      'JPY': '¥',
      'CNY': '¥',
    };
    return symbols[currencyCode] ?? currencyCode;
  }

  /// Get locale for currency
  static String _getLocaleForCurrency(String currencyCode) {
    const locales = {
      'IDR': 'id_ID',
      'USD': 'en_US',
      'EUR': 'de_DE',
      'SGD': 'en_SG',
      'MYR': 'ms_MY',
      'PHP': 'fil_PH',
      'THB': 'th_TH',
      'GBP': 'en_GB',
      'JPY': 'ja_JP',
      'CNY': 'zh_CN',
    };
    return locales[currencyCode] ?? 'id_ID';
  }

  /// Get list of supported currencies
  static List<Map<String, String>> getSupportedCurrencies() {
    return [
      {
        'code': 'IDR',
        'name': 'Indonesian Rupiah',
        'symbol': _getCurrencySymbol('IDR'),
      },
      {'code': 'USD', 'name': 'US Dollar', 'symbol': _getCurrencySymbol('USD')},
      {'code': 'EUR', 'name': 'Euro', 'symbol': _getCurrencySymbol('EUR')},
      {
        'code': 'SGD',
        'name': 'Singapore Dollar',
        'symbol': _getCurrencySymbol('SGD'),
      },
      {
        'code': 'MYR',
        'name': 'Malaysian Ringgit',
        'symbol': _getCurrencySymbol('MYR'),
      },
      {
        'code': 'PHP',
        'name': 'Philippine Peso',
        'symbol': _getCurrencySymbol('PHP'),
      },
      {'code': 'THB', 'name': 'Thai Baht', 'symbol': _getCurrencySymbol('THB')},
      {
        'code': 'GBP',
        'name': 'British Pound',
        'symbol': _getCurrencySymbol('GBP'),
      },
      {
        'code': 'JPY',
        'name': 'Japanese Yen',
        'symbol': _getCurrencySymbol('JPY'),
      },
      {
        'code': 'CNY',
        'name': 'Chinese Yuan',
        'symbol': _getCurrencySymbol('CNY'),
      },
    ];
  }

  /// Format untuk display di table/list
  static String formatCompact(double amount, {String currencyCode = 'IDR'}) {
    if (amount >= 1000000) {
      return '${_getCurrencySymbol(currencyCode)} ${(amount / 1000000).toStringAsFixed(1)}M';
    } else if (amount >= 1000) {
      return '${_getCurrencySymbol(currencyCode)} ${(amount / 1000).toStringAsFixed(1)}K';
    } else {
      return format(amount, currencyCode: currencyCode);
    }
  }
}
