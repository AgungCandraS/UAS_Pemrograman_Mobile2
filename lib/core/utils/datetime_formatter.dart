import 'package:intl/intl.dart';

/// Date and time formatting utility
class DateTimeFormatter {
  /// Format date sesuai format yang dipilih
  static String formatDate(DateTime date, {String format = 'dd/MM/yyyy'}) {
    try {
      final formatter = DateFormat(_convertToIntlFormat(format));
      return formatter.format(date);
    } catch (e) {
      return date.toString().split(' ')[0]; // fallback
    }
  }

  /// Format time sesuai format yang dipilih
  static String formatTime(DateTime dateTime, {String format = '24h'}) {
    try {
      final pattern = format == '24h' ? 'HH:mm:ss' : 'hh:mm:ss a';
      final formatter = DateFormat(pattern);
      return formatter.format(dateTime);
    } catch (e) {
      return dateTime.toString();
    }
  }

  /// Format date dan time
  static String formatDateTime(
    DateTime dateTime, {
    String dateFormat = 'dd/MM/yyyy',
    String timeFormat = '24h',
  }) {
    final date = formatDate(dateTime, format: dateFormat);
    final time = formatTime(dateTime, format: timeFormat);
    return '$date $time';
  }

  /// Convert format code ke intl format
  static String _convertToIntlFormat(String format) {
    const formats = {
      'dd/MM/yyyy': 'dd/MM/yyyy',
      'MM/dd/yyyy': 'MM/dd/yyyy',
      'yyyy-MM-dd': 'yyyy-MM-dd',
      'dd-MM-yyyy': 'dd-MM-yyyy',
      'yyyy/MM/dd': 'yyyy/MM/dd',
    };
    return formats[format] ?? 'dd/MM/yyyy';
  }

  /// Get list of supported date formats
  static List<Map<String, String>> getSupportedDateFormats() {
    return [
      {'code': 'dd/MM/yyyy', 'name': 'DD/MM/YYYY', 'example': '25/12/2024'},
      {'code': 'MM/dd/yyyy', 'name': 'MM/DD/YYYY', 'example': '12/25/2024'},
      {'code': 'yyyy-MM-dd', 'name': 'YYYY-MM-DD', 'example': '2024-12-25'},
      {'code': 'dd-MM-yyyy', 'name': 'DD-MM-YYYY', 'example': '25-12-2024'},
      {'code': 'yyyy/MM/dd', 'name': 'YYYY/MM/DD', 'example': '2024/12/25'},
    ];
  }

  /// Get list of supported time formats
  static List<Map<String, String>> getSupportedTimeFormats() {
    return [
      {'code': '24h', 'name': '24-hour (HH:mm)', 'example': '14:30'},
      {'code': '12h', 'name': '12-hour (hh:mm AM/PM)', 'example': '02:30 PM'},
    ];
  }

  /// Parse date string
  static DateTime? parseDate(
    String dateString, {
    String format = 'dd/MM/yyyy',
  }) {
    try {
      final formatter = DateFormat(_convertToIntlFormat(format));
      return formatter.parse(dateString);
    } catch (e) {
      return null;
    }
  }

  /// Get relative time (e.g., "2 hours ago")
  static String getRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return 'just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else if (difference.inDays < 30) {
      return '${(difference.inDays / 7).floor()}w ago';
    } else if (difference.inDays < 365) {
      return '${(difference.inDays / 30).floor()}mo ago';
    } else {
      return '${(difference.inDays / 365).floor()}y ago';
    }
  }

  /// Format untuk display di activity logs
  static String formatActivityTime(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final dateOnly = DateTime(dateTime.year, dateTime.month, dateTime.day);

    if (dateOnly == today) {
      return 'Today ${formatTime(dateTime)}';
    } else if (dateOnly == yesterday) {
      return 'Yesterday ${formatTime(dateTime)}';
    } else {
      return formatDateTime(dateTime);
    }
  }
}
