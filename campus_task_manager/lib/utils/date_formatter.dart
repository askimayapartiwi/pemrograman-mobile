import 'package:intl/intl.dart';

class DateFormatter {

  static String formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return '-';
    return DateFormat('dd MMM yyyy, HH:mm').format(dateTime);
  }

  static String formatDate(DateTime? date) {
    if (date == null) return '-';
    return DateFormat('EEEE, dd MMMM yyyy', 'id_ID').format(date);
  }

  static String formatTime(DateTime? date) {
    if (date == null) return '-';
    return DateFormat('HH:mm').format(date);
  }

  static String formatRelativeDate(DateTime? date) {
    if (date == null) return 'Tidak ada deadline';

    final now = DateTime.now();
    final difference = date.difference(now);

    if (difference.isNegative) {
      final overdue = now.difference(date);
      if (overdue.inDays > 0) {
        return 'Terlambat ${overdue.inDays} hari';
      } else if (overdue.inHours > 0) {
        return 'Terlambat ${overdue.inHours} jam';
      } else {
        return 'Terlambat ${overdue.inMinutes} menit';
      }
    }

    if (difference.inDays > 0) {
      return '${difference.inDays} hari lagi';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} jam ${difference.inMinutes.remainder(60)} menit';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} menit';
    } else {
      return 'Segera!';
    }
  }

  static String getDayName(DateTime? date) {
    if (date == null) return '-';
    return DateFormat('EEEE', 'id_ID').format(date);
  }

  static String getMonthName(DateTime? date) {
    if (date == null) return '-';
    return DateFormat('MMMM', 'id_ID').format(date);
  }

  static DateTime getStartOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  static DateTime getEndOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day, 23, 59, 59, 999);
  }

  static bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
           date1.month == date2.month &&
           date1.day == date2.day;
  }
}
