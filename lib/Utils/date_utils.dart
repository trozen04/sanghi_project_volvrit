import 'package:intl/intl.dart';

/// Formats a given ISO date string into "Month day, Weekday"
/// Example: "2025-10-01T12:45:38.087Z" -> "October 1, Wednesday"
String formatNotificationDate(String? isoDate) {
  if (isoDate == null || isoDate.isEmpty) return '';

  try {
    final dateTime = DateTime.parse(isoDate);
    final month = DateFormat.MMMM().format(dateTime);   // October
    final day = dateTime.day;                           // 1
    final weekday = DateFormat.EEEE().format(dateTime); // Wednesday
    return '$month $day, $weekday';
  } catch (e) {
    return '';
  }
}
