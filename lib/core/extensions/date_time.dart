import 'package:intl/intl.dart' show DateFormat;

extension DateTimeExt on DateTime {
  /// Format Datetime to `dd/MM/yyyy HH:mm` string
  String get ddMMyyyyHHmm => DateFormat('dd/MM/yyyy HH:mm').format(this);

  /// Format Datetime to `dd/MM/yyyy` string
  String get ddMMyyyy => DateFormat('dd/MM/yyyy').format(this);

  /// Format Datetime to "HH:mm a" or "E" or "MMM d" based on the difference now.
  String get dynamicDate {
    final now = DateTime.now();
    final difference = now.difference(this);

    if (difference.inDays == 0) {
      return DateFormat('HH:mm a').format(this); // Same day
    } else if (difference.inDays.abs() < 7) {
      return DateFormat.E().format(this); // Within the same week
    } else {
      return DateFormat('MMM d').format(this); // More than a week ago
    }
  }

  String get hhmmaa => DateFormat('HH:mm aa').format(this);

  String formatDateForSeparator() {
    final now = DateTime.now();
    if (now.year == year) {
      return DateFormat('MMM d').format(this);
    } else {
      return DateFormat('MMM d, yyyy').format(this);
    }
  }

  bool isSameDay(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }
}

extension TimeFormat on int {
  String get toTime {
    int hours = this ~/ 3600;
    int minutes = (this % 3600) ~/ 60;
    int seconds = this % 60;

    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}h${minutes.toString().padLeft(2, '0')}m${seconds.toString().padLeft(2, '0')}s';
    } else if (minutes > 0) {
      return '${minutes.toString().padLeft(2, '0')}m${seconds.toString().padLeft(2, '0')}s';
    } else {
      return '${seconds.toString().padLeft(2, '0')}s';
    }
  }
}
