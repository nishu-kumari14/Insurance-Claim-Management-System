import 'package:intl/intl.dart';

class AppFormatters {
  static String formatCurrency(double amount) {
    final formatter = NumberFormat.currency(
      locale: 'en_US',
      symbol: '\$',
      decimalDigits: 2,
    );
    return formatter.format(amount);
  }

  static String formatDate(DateTime date) {
    final formatter = DateFormat('MMM dd, yyyy');
    return formatter.format(date);
  }

  static String formatDateTime(DateTime dateTime) {
    final formatter = DateFormat('MMM dd, yyyy - hh:mm a');
    return formatter.format(dateTime);
  }

  static String formatTime(DateTime dateTime) {
    final formatter = DateFormat('hh:mm a');
    return formatter.format(dateTime);
  }

  static String formatShortDate(DateTime date) {
    final formatter = DateFormat('MM/dd/yy');
    return formatter.format(date);
  }

  static String formatPercent(double value) {
    return '${(value * 100).toStringAsFixed(2)}%';
  }

  static String truncateString(String string, int length) {
    if (string.length <= length) {
      return string;
    }
    return '${string.substring(0, length)}...';
  }
}
