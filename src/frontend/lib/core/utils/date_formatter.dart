import 'package:intl/intl.dart';

/// Date formatting utilities
class DateFormatter {
  // Date format patterns
  static const String _datePattern = 'yyyy/MM/dd';
  static const String _timePattern = 'HH:mm:ss';
  static const String _dateTimePattern = 'yyyy/MM/dd HH:mm:ss';
  static const String _shortDatePattern = 'MM/dd';
  static const String _monthYearPattern = 'yyyy/MM';

  // Formatters
  static final DateFormat _dateFormatter = DateFormat(_datePattern);
  static final DateFormat _timeFormatter = DateFormat(_timePattern);
  static final DateFormat _dateTimeFormatter = DateFormat(_dateTimePattern);
  static final DateFormat _shortDateFormatter = DateFormat(_shortDatePattern);
  static final DateFormat _monthYearFormatter = DateFormat(_monthYearPattern);

  /// Format date as 'yyyy/MM/dd'
  static String formatDate(DateTime date) {
    return _dateFormatter.format(date);
  }

  /// Format time as 'HH:mm:ss'
  static String formatTime(DateTime date) {
    return _timeFormatter.format(date);
  }

  /// Format date and time as 'yyyy/MM/dd HH:mm:ss'
  static String formatDateTime(DateTime date) {
    return _dateTimeFormatter.format(date);
  }

  /// Format date as 'MM/dd'
  static String formatShortDate(DateTime date) {
    return _shortDateFormatter.format(date);
  }

  /// Format date as 'yyyy/MM'
  static String formatMonthYear(DateTime date) {
    return _monthYearFormatter.format(date);
  }

  /// Parse date string 'yyyy/MM/dd' to DateTime
  static DateTime? parseDate(String dateString) {
    try {
      return _dateFormatter.parse(dateString);
    } catch (e) {
      return null;
    }
  }

  /// Parse datetime string 'yyyy/MM/dd HH:mm:ss' to DateTime
  static DateTime? parseDateTime(String dateTimeString) {
    try {
      return _dateTimeFormatter.parse(dateTimeString);
    } catch (e) {
      return null;
    }
  }

  /// Get relative time string (e.g., "2 hours ago", "5 minutes ago")
  static String getRelativeTime(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return '$years年前';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return '$monthsヶ月前';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}日前';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}時間前';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}分前';
    } else {
      return 'たった今';
    }
  }

  /// Check if date is today
  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  /// Check if date is within the last N days
  static bool isWithinDays(DateTime date, int days) {
    final now = DateTime.now();
    final difference = now.difference(date);
    return difference.inDays <= days;
  }
}
