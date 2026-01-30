import 'package:intl/intl.dart';
import 'package:bisnisku/config/constants/app_constants.dart';

/// Utility class for formatting values
class Formatters {
  Formatters._();

  /// Format currency (Indonesian Rupiah)
  static String currency(num value, {bool includeSymbol = true}) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: includeSymbol ? AppConstants.currencySymbol : '',
      decimalDigits: 0,
    );
    return formatter.format(value);
  }

  /// Format number with thousand separators
  static String number(num value, {int? decimalDigits}) {
    final formatter = NumberFormat.decimalPattern('id_ID');
    if (decimalDigits != null) {
      formatter.minimumFractionDigits = decimalDigits;
      formatter.maximumFractionDigits = decimalDigits;
    }
    return formatter.format(value);
  }

  /// Format percentage
  static String percentage(num value, {int decimalDigits = 1}) {
    return '${value.toStringAsFixed(decimalDigits)}%';
  }

  /// Format date
  static String date(DateTime date, {String? format}) {
    final formatter = DateFormat(format ?? AppConstants.dateFormat, 'id_ID');
    return formatter.format(date);
  }

  /// Format date time
  static String dateTime(DateTime date, {String? format}) {
    final formatter = DateFormat(
      format ?? AppConstants.dateTimeFormat,
      'id_ID',
    );
    return formatter.format(date);
  }

  /// Format time
  static String time(DateTime date, {String? format}) {
    final formatter = DateFormat(format ?? AppConstants.timeFormat, 'id_ID');
    return formatter.format(date);
  }

  /// Format relative time (e.g., "2 hours ago")
  static String relativeTime(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()} tahun yang lalu';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()} bulan yang lalu';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} hari yang lalu';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} jam yang lalu';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} menit yang lalu';
    } else {
      return 'Baru saja';
    }
  }

  /// Format file size
  static String fileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  /// Format phone number
  static String phoneNumber(String phone) {
    // Remove all non-digit characters
    final cleaned = phone.replaceAll(RegExp(r'\D'), '');

    // Format as: 0812-3456-7890
    if (cleaned.length >= 10) {
      return '${cleaned.substring(0, 4)}-${cleaned.substring(4, 8)}-${cleaned.substring(8)}';
    }

    return cleaned;
  }
}
