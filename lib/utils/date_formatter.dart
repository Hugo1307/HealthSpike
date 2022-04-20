import 'package:intl/intl.dart';

class DateFormatter {
  static String format(DateTime dateTime, DateFormat dateFormat) {
    return dateFormat.format(dateTime);
  }
}
